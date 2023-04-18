require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/http-party/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-14.1.1.tgz"
  sha256 "9e1ceb265d09a4d86dcf509cb4ba6dcd2e03254b1d13030198766fe3897fd7a5"
  license "MIT"
  head "https://github.com/http-party/http-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e9d67691b2b1afcbff2ecaf2730ad9306e3d04f546d466a963bc8c9d0e0de6f"
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
