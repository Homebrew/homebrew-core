class PrismCli < Formula
  desc "Set of packages for API mocking and contract testing"
  homepage "https://stoplight.io/open-source/prism"
  url "https://registry.npmjs.org/@stoplight/prism-cli/-/prism-cli-5.14.2.tgz"
  sha256 "61a3b45fbb0325b85fbe94baf836588de676c0db91c3b1f191738070c2f7410f"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7800a83ca6cb47e11df9264d4ff6e06d6ee0a5d5e6cba2456c98198c4f50046a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Backport https://github.com/stoplightio/json-schema-ref-parser/commit/ab6ad5a312672c37fd5936d3cef78fbf0ad85234
    node_modules = libexec/"lib/node_modules/@stoplight/prism-cli/node_modules"
    inreplace node_modules/"@stoplight/json-schema-ref-parser/lib/resolvers/http.js",
      'const { AbortController } = require("node-abort-controller");',
      ""
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
