require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/http-party/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-0.12.3.tgz"
  sha256 "7a4f4c768bedbdfd72de849efcbf65a437000004f5cabf958bc2d73caa1a1623"
  head "https://github.com/http-party/http-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d54d568edf8a41ba191780c8a5afbc283afc49a71db6a47259752eedbcd157b1" => :catalina
    sha256 "abbcfb975903d901ed6e2d81e93f527143c76ac1813d181d8a4cbb6c4de58dbe" => :mojave
    sha256 "df39f65c35d983da959f812f94ba676aa616b7c79ccb4385978ac37ec0055274" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/http-server", "-p#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match /200 OK/m, output
  ensure
    Process.kill("HUP", pid)
  end
end
