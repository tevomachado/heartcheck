require 'json'

module Heartcheck
  module Checks
    class WatchFile < Base
      def add_service(options)
        services << options.merge(runtime: installed(options[:file]))
      end

      def validate
        services.each do |service|
          if not service[:runtime].eql? installed(service[:file])
            @errors << "App outdated, check info for the diff"
          end
        end
      end

      def info
        services.collect do |service|
          { runtime: service[:runtime], installed: installed(service[:file]) }
        end
      end

      private

      def installed(file)
        JSON.parse open(file).read
      end
    end
  end
end