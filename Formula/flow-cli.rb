class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.15.0.tar.gz"
  sha256 "6b34db0ebfb84192b6352b1ecbe489a94d0810b518573c5bfef3b86b810ce9d5"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bab0c5544671b385a11b31e74b8377163ed325ead8a6dd3415e960a7e7fcac79"
    sha256 cellar: :any_skip_relocation, big_sur:       "f373fde61faf3cc62eea0cf7777984200511eb65045fb361c0e069417814ea4b"
    sha256 cellar: :any_skip_relocation, catalina:      "75b1f1a8fd72e843b3233dd97a09b593dff03d637359c0181355d663cd8daed6"
    sha256 cellar: :any_skip_relocation, mojave:        "bb169083ad3f07e985232888fcccaa15ad01d06bf9b4f4fdc12021d4db0e1e34"
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
