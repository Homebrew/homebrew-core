class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.26.0.tar.gz"
  sha256 "0a08487015e5e9a379a5152fc345768e5301d40e9c67c5ef5bd9268c9046d5bc"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "74efff382f9b42e1044b7efe8e9c6a04aba5c09981ba4ecd1a0b78ac45e2df62"
    sha256 cellar: :any_skip_relocation, big_sur:       "24f0e9e57b1727e5a5b2c4bcab71fcc9abcf3cc4c7fe163455beaec321b18ae4"
    sha256 cellar: :any_skip_relocation, catalina:      "e18d1a74449b1a73284c886d2e2232c2b2b350937f32533e0a624b6ba553d6c3"
    sha256 cellar: :any_skip_relocation, mojave:        "33859d7770b8e076cca83e35c446a1a33885d303e1826e75e9416aab480504c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8712ccc843d59dc681b59ec5cf3e138ab37328d0c841eda8d676bf046ab6f8d"
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
