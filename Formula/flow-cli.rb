class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.43.0.tar.gz"
  sha256 "e8aef8f82db1b219568229fbf17b0bf0b1e9a634610a89288b38c41296a3873f"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1437ae2a9f2bf521e248311e04570df92725ebc0f2d8dd1900a8e12c6b85620"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce44af1e8a9cab8d8bd622f49ae540ef1b4f1498532e61067b7fb77f611031ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7821c378c1e67ed3417bfafd9fd58c2d1acd27ca09d0b62586243f2bbaca491"
    sha256 cellar: :any_skip_relocation, ventura:        "7e9015ed56417a79cc1511764edaf3a0e7354bd21d9d8c085b475b01aebddd48"
    sha256 cellar: :any_skip_relocation, monterey:       "35b92201d461265aa1bbf445ccd9ac340bf7f1e7afc9e700974bac42ee869db5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9c180d0ae2a11d2e0b147a9e40c6ea4769bca4816699e522cc894659c498a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d0db70b5f424487a0f57fd700e421e64aa709de0f65a691e7726af0b77cd69e"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
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
