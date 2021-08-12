require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/http-party/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-13.0.0.tgz"
  sha256 "325efc8e97e991840e7161f42cbafc9103f967f57b5fc014659974a9c36adb48"
  license "MIT"
  head "https://github.com/http-party/http-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f754a7268fe26f330053fbf3b15aa00e99f01e05c4691f3f54c1e5902f46955"
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
