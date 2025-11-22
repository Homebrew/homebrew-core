class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "fe3bb6ddcb4239adb5981e0cc4bc40f1bcae2d1397a5997e75fc0157cfc5ce5a"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f4a2494bc7372db9b11bbcf53242afa7c90fc6b24838760fc64170cc4a27018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea92cc4df1ab1a487ca0c1fe3340b85d0081de2433e4fe0deb52f76fdc512998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c94bb9ccdfa869d05fb06a63454872e96985eccb23008a9c0e91e8cde2e7ee7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d24beaf2b3392adcb321e3587aacae508cebeb9caf3400eb6009306ad7419de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "830ad104e4f7a2c29a7832b345c8a5c7971bef031b148439c234ad2a3ddfe977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a84fca4fc4a55c529a9d84f7a6bd0810d7be92bf1e23710f9207c8ccefde532d"
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
