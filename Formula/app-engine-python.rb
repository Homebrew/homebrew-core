class AppEnginePython < Formula
  desc "Google App Engine"
  homepage "https://cloud.google.com/appengine/docs"
  url "https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.86.zip"
  sha256 "8a1d57f8819792a4c18bc337762f73f3bf207da986fd6028e3e591f24cfde9f2"

  bottle :unneeded

  def install
    pkgshare.install Dir["*"]
    %w[
      _python_runtime.py
      _php_runtime.py
      api_server.py
      appcfg.py
      backends_conversion.py
      bulkload_client.py
      bulkloader.py
      dev_appserver.py
      download_appstats.py
      endpointscfg.py
      gen_protorpc.py
      php_cli.py
      remote_api_shell.py
      run_tests.py
      wrapper_util.py
    ].each do |fn|
      bin.install_symlink share/name/fn
    end
  end

  test do
    (testpath/"app.yaml").write <<~EOS
      runtime: python27
      api_version: 1
      threadsafe: true

      handlers:
      - url: /.*
        script: main.app

    EOS
    (testpath/"main.py").write <<~EOS
      import webapp2
      class MainPage(webapp2.RequestHandler):
        def get(self):
          self.response.headers['Content-Type'] = 'text/plain'
          self.response.write('Hello, World!')
      app = webapp2.WSGIApplication([
        ('/', MainPage),
      ], debug=True)
    EOS

    port = free_port
    begin
      pid = fork do
        exec "#{pkgshare}/dev_appserver.py app.yaml --skip_sdk_update_check --port #{port}"
      end
      sleep 5
      output = shell_output("curl -s http://localhost:#{port}/")
      assert_equal "Hello, World!", output.chomp
    ensure
      Process.kill("HUP", pid)
    end
  end
end
