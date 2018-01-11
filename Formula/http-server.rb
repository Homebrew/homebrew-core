require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/indexzero/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-0.11.1.tgz"
  sha256 "4154aba3e09f21595e26fdd174d9773e22755c0009f661bed54b8647fc987d95"
  head "https://github.com/indexzero/http-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af982b9ac624f71af5cab4bdeac3dfc5a5ebe02b28407026355ea5df72062226" => :high_sierra
    sha256 "acec023e4e144eae500d50167cf8fb3588fe2d08c431ba5a7cbc1ec6fab739e5" => :sierra
    sha256 "d27b46feb2604d39f9dd24e7fc385de28af3651f26c0ef35ab18e6369b08f4e1" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/http-server"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match /200 OK/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
