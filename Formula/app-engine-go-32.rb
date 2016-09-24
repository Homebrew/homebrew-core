class AppEngineGo32 < Formula
  desc "Google App Engine SDK for Go (i386)"
  homepage "https://cloud.google.com/appengine/docs/go/"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_386-1.9.40.zip"
  sha256 "c00fe83a06816ae5fbe7b1e9b41268d675cd270d34412cf4806097479d5a0be7"

  bottle :unneeded

  conflicts_with "app-engine-go-64",
    :because => "both install the same binaries"
  conflicts_with "app-engine-python",
    :because => "both install the same binaries"

  def install
    pkgshare.install Dir["*"]
    %w[
      api_server.py appcfg.py bulkloader.py bulkload_client.py dev_appserver.py download_appstats.py goapp
    ].each do |fn|
      bin.install_symlink pkgshare/fn
    end
    (pkgshare/"goroot/pkg").install_symlink pkgshare/"goroot/pkg/darwin_386_appengine" => "darwin_386"
  end

  test do
    assert_match(/^usage: goapp serve/, shell_output("#{bin}/goapp help serve").strip)
  end
end
