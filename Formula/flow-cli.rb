class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.28.4.tar.gz"
  sha256 "69d5f85e3e1a62c22384ad878c60ae6fd1a6c9449ee603f30b8a8e4b434f5249"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a60f237fcf051fb9b3a5508a274a9635c652aa2027f494cd955c6754545ca01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73cc245a040138fcb96c98cf47cdd2c89d737ea038381584a23743a53a10f637"
    sha256 cellar: :any_skip_relocation, monterey:       "aea99f714a41c1ae126ff5f65f09aaf085afbd63f39ef06213bd99cb214d7f83"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe1ac0c212a45281d430b9f1958894f57e8f2f91d984df766dcf831a2c691eed"
    sha256 cellar: :any_skip_relocation, catalina:       "b4ba774458e8f78917ec5c4a43f21921bdcc052f3b88ae95442532ddecf80b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d6e22c6624859b6aace1c5d24676e3bd33a66866c0a3478752089f173442d9a"
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
