class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/http-party/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-14.1.1.tgz"
  sha256 "9e1ceb265d09a4d86dcf509cb4ba6dcd2e03254b1d13030198766fe3897fd7a5"
  license "MIT"
  head "https://github.com/http-party/http-server.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "255fa4f7d541f2485fc11af34b8d240785fd6b364d7e98eae44800da7dcf87d1"
  end

  depends_on "node"

  conflicts_with "http-server-rs", because: "both install a `http-server` binary"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port

    pid = spawn bin/"http-server", "-p#{port}"
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "200 OK", output
  ensure
    Process.kill("HUP", pid)
  end
end
