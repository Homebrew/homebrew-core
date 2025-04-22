class PrismCli < Formula
  desc "Set of packages for API mocking and contract testing"
  homepage "https://stoplight.io/open-source/prism"
  url "https://registry.npmjs.org/@stoplight/prism-cli/-/prism-cli-5.14.2.tgz"
  sha256 "61a3b45fbb0325b85fbe94baf836588de676c0db91c3b1f191738070c2f7410f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8333b92f1cfcab951b0ebd6506a1c3449a31e7ea128bfdb68c09a43f8f925fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8333b92f1cfcab951b0ebd6506a1c3449a31e7ea128bfdb68c09a43f8f925fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8333b92f1cfcab951b0ebd6506a1c3449a31e7ea128bfdb68c09a43f8f925fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "54e69a8479659e2bb814608927794cb89b42b50e0d76f8d7694696bfa62dd390"
    sha256 cellar: :any_skip_relocation, ventura:       "54e69a8479659e2bb814608927794cb89b42b50e0d76f8d7694696bfa62dd390"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8333b92f1cfcab951b0ebd6506a1c3449a31e7ea128bfdb68c09a43f8f925fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8333b92f1cfcab951b0ebd6506a1c3449a31e7ea128bfdb68c09a43f8f925fe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
    pid = spawn bin/"prism", "mock", "--port", port.to_s, "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/refs/tags/3.1.1/examples/v3.0/petstore.yaml"

    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    system "curl", "http://127.0.0.1:#{port}/pets"

    assert_match version.to_s, shell_output("#{bin}/prism --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
