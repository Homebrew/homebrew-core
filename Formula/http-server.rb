require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/http-party/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-14.1.0.tgz"
  sha256 "98437beb1fdb90768092f0208849bd283b1bbd4e07197b7bbf4269648a1507f7"
  license "MIT"
  head "https://github.com/http-party/http-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cd4292d5529f09e3a9f6395195a4320f43d7b599783528a37faa7174bfb9025"
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
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "200 OK", output
  ensure
    Process.kill("HUP", pid)
  end
end
