require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/http-party/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-0.12.3.tgz"
  sha256 "7a4f4c768bedbdfd72de849efcbf65a437000004f5cabf958bc2d73caa1a1623"
  license "MIT"
  head "https://github.com/http-party/http-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11f0b3f7fc0975e2eb7c911fe1555c13527f75ea5468215e6d6340e11bf36f33" => :catalina
    sha256 "fcc2086b4000cc47077413c116c09ee4b60fe9b064f7d95ff7c19c966a181d4f" => :mojave
    sha256 "1b3f5212bc710e5ae053bbd9fb3bd279d763ad03e6c550425ab95534e309a9ef" => :high_sierra
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
