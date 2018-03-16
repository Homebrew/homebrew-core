class AppEnginePython < Formula
  desc "Google App Engine"
  homepage "https://cloud.google.com/appengine/docs"
  url "https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.67.zip"
  sha256 "f9f45150643424cb164185d9134b86511c2bec3001499247ef9027f1605ef8a3"

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
      google_sql.py
      php_cli.py
      remote_api_shell.py
      run_tests.py
      wrapper_util.py
    ].each do |fn|
      bin.install_symlink share/name/fn
    end
  end
end
