class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.23.0.tar.gz"
  sha256 "574502827cb85f1b3bbde8be7e7adb5e1500ad1c828db5e69360a5c57fb5ba26"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e18738199822011a7d66bc25dddacaa421dc6e30e9232f6317794ce1b220658d"
    sha256 cellar: :any_skip_relocation, big_sur:       "813d3feb6e50b2a62fbe9b6d81571011d5363dde31c0e63078cb0c4e06df41ee"
    sha256 cellar: :any_skip_relocation, catalina:      "aeab6343dbd0f6247d7e10b6d8a1eccf8655709478f7e3b02f17683a417083ed"
    sha256 cellar: :any_skip_relocation, mojave:        "32ead8850a3ee75a8f86d5418bfbf9c3154166bfcf49c2001af8e5c375f281d5"
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
