class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.3.0",
      revision: "4134777c293b07e0df867f5a8f68bc2e6dcae3e8"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a057edc4d4e294e9f868f0949208658da81865a7e33e79c5e5d523c7be90205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f334d5a15e41d04e07e24cd13d1394b3cc0cb02abe1d6fd0d2cf43d895c3ffd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b4ce71c795476fa278a46d0c3d825eae6651eba6a1cbfd6367b7f6114e5f9b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b309158aa47a4729246b49c5c6f23e666322c67e60ee06e7a5b53010414b1ded"
    sha256 cellar: :any_skip_relocation, ventura:       "ac5c4906807fa8a4db6ae845565f33e75ed476c385aa124635a187bcee6fd084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bc7b05e63831241f86e8064e26a9187dd8bf2f51f0fd9cb97390a235dd5abb8"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
    system "make", ".just-build"
    make_args = %w[
      cadence
      cadence-server
      cadence-canary
      cadence-sql-tool
      cadence-cassandra-tool
    ]
    make_args << "EMULATE_X86=" unless Hardware::CPU.intel?
    system "make", *make_args

    bin.install "cadence"
    bin.install "cadence-server"
    bin.install "cadence-canary"
    bin.install "cadence-sql-tool"
    bin.install "cadence-cassandra-tool"

    (etc/"cadence").install "config", "schema"
  end

  test do
    output = shell_output("#{bin}/cadence-server start 2>&1", 1)
    assert_match "no config files found within ./config", output

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc 2>&1", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end
