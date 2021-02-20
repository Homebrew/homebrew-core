class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.13.4.tar.gz"
  sha256 "4a6d248db4ce0a29cb3aa0b5575c239ebe32c5c75ed253a1fe862c84553f6b5c"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8f039b06734c3ea3e6e083d71956333ab62f8e9c75b826006442136e83800d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "26f2ff6a2154d71d2268bd9a232aa9ecc3081c671c57ae7cefad8d800ee930d0"
    sha256 cellar: :any_skip_relocation, catalina:      "d99a2857dca3ef9095b0fd7fbfeafedf8675475d8bbfdb9b9afb372e59b23591"
    sha256 cellar: :any_skip_relocation, mojave:        "48b8177bca20f2504c20389f2c15031e4e0ab2d675545710c199ef36ff618916"
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
