class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.17.4.tar.gz"
  sha256 "9d3e89a99405cfa7b2bbc07db6530ea65a8b6537aff381fe61e4a74f2afd8c3f"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c36d514d70d4c1c9d5741d8c1eb6b627147d9b679d074eb52fee92f240a262d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5002dbfe838b9eadfaf71c824eecac942c104482b6c5c53f5f4c470eb2fe8210"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8b13337076ee85e84c337c235bd0d128bf064d662fbc933f5a6c44281c113c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dce70cb710abd43a64a7ec778b35f4ecc630fa286c4805a972e2a58f3ee3ab9"
    sha256 cellar: :any,                 arm64_linux:   "c7234e9488456e929816a415be2ca14d3cdf1c25f64d88c6ffb06b8be8d966f5"
    sha256 cellar: :any,                 x86_64_linux:  "ef4b2c0411c9f25ecba1577752ccae47e32b76494485893010fe0dba95865883"
  end

  depends_on "go@1.25" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow version")

    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
