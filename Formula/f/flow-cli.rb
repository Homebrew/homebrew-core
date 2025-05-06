class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.2.13.tar.gz"
  sha256 "bd84caa459bd8e5de4ce762f9ebc923fde67a10c95c5328c809d9ce897b6b397"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0b533f6468495bfe2ce0c4027e220b47474c37a721882d878fab34c1d4aa2fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be2b6b0c61ca81ca017e9fec0d7efb3b37437cc64507cf6b7d7e1f78e2fecfc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c378904e0ebd11b8975cc25592396188b90ecbf0049d8faa82fb1682782bcc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ed19d894f0d0d5b7c617830103a1b0050b8f3abd4173b5dbf129581169c8169"
    sha256 cellar: :any_skip_relocation, ventura:       "346febb02f537405c6dae7f70caabe1c46b2ff03e0387c84debc3bdb72bf35ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c00d61be263375d7be29c643f23135e8a794c0d10c79dce620175e90ee129bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a080da468f50926d4ae50d2aedeec2a0132e4473115949a25ebe3b23988257"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
