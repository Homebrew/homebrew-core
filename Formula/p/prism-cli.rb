class PrismCli < Formula
  desc "Set of packages for API mocking and contract testing"
  homepage "https://stoplight.io/open-source/prism"
  url "https://registry.npmjs.org/@stoplight/prism-cli/-/prism-cli-5.15.11.tgz"
  sha256 "0e3594a4e30afb747d6d9e5ff8a61004fd5c596f4f46e3685ab1aafcbb5474fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7e8aecb82bb0a2fa5f374894fef957cc3eae8eaf9058246b2eeee1978bf49e2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    port = free_port
    pid = spawn bin/"prism", "mock", "--port", port.to_s, "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/refs/tags/3.1.1/examples/v3.0/petstore.yaml"

    sleep 10
    sleep 15 if OS.mac? && Hardware::CPU.intel?

    system "curl", "http://127.0.0.1:#{port}/pets"

    assert_match version.to_s, shell_output("#{bin}/prism --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
