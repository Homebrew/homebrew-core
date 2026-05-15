class PrismCli < Formula
  desc "Set of packages for API mocking and contract testing"
  homepage "https://stoplight.io/open-source/prism"
  url "https://registry.npmjs.org/@stoplight/prism-cli/-/prism-cli-5.15.10.tgz"
  sha256 "280e3ffc4ffd9fe23c2cbdf911221fe1b5c745486746191d7ca724248ac9ac08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "074332404299443f6edaeebaeb0451584e2909da9d406c692ca10e4a6d697dbc"
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
