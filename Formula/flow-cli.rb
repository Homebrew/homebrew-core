class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.30.3.tar.gz"
  sha256 "9dfe1d478e77157d6cb0644099500fc27116026b0dd3428d00d3f9fd5db95941"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf09a3559d35af931577946d30f4ae50c6f3778429c1d76c344711a3b60a43d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aea271f81e7ac71edc7b20a9c119a9141aa4f24ffe1a22ca696d75727796f7af"
    sha256 cellar: :any_skip_relocation, monterey:       "a6b3779c092d8ef169992b278c147c91a386e1d274d2b5b711ecb0d49a3cfcdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3716d4a250dfc2519e70558402feec8fd0cf7e081648fc5e4ec4b070ee09755f"
    sha256 cellar: :any_skip_relocation, catalina:       "fe3ef0ecf6ff86777db4eca73a785d9a75f5838fc0471cb5be69e757809d0073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9fc2ed86ee0d60cf978983f63de46b2d44ccf1cec0cb4353fcd589c28284c8a"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
