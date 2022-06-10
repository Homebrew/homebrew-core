class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.36.0.tar.gz"
  sha256 "b3bb705524e2d886e2cdb90b67c2774179deebfd8cc4ab6ee0996eae8ef6d904"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb90538d262417ec2f16ad894c27e04b9ee6704c22b739e5746d39ee0b46306"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c4edf83bb8e2d110abafca5362fe8552b1ca0e27cbaa21267ae72dcd5cd7a8f"
    sha256 cellar: :any_skip_relocation, monterey:       "753f88aa40efb566b6101f3d7355f721af4185bc610b305830a21b52ae2de19d"
    sha256 cellar: :any_skip_relocation, big_sur:        "15611881ac5ba7d65f52417410984a1d0bb5a360e32469dbc56906fbe5ac0b78"
    sha256 cellar: :any_skip_relocation, catalina:       "e2f4a0917012c125cf298f54911a1a4e1ae12afb29d2dbe539f10c9d2a271aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebd5a09559525d81500fdc924a4fb354be3bd0cc4d6186443a6eae60f75ea936"
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
