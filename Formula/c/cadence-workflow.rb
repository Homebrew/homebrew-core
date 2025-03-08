class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.17",
      revision: "f71721392189675e3ead51709a6cfbcdbb2a51d8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bf6f55382bb9c143b007751490b4846b8abcbf1f9d2a36998a84f7e5b67d6f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "815a4824b8bd8802703cf1ca7027b97d7bdedcfb34268a512cf1ecb65dab65d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dda8da993523b4977cfebd0ac229e7509378258572d1cb4080371bc466093896"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f4f6a0753ee946a9e3bf4c206a9b8030cd16af8dac1011c921b6a07d71bce56"
    sha256 cellar: :any_skip_relocation, ventura:       "750382f8913d2a6d686e3de83005a47a16d1274836839f3cb982d449cb3da03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32f1cb58a82058cc72b8197aece606d78ffd58c56a64e55246e09329c5a18828"
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
    assert_match "Loading config; env=development,zone=,configDir", output

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc 2>&1", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end
