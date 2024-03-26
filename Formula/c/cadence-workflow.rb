class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.8",
      revision: "3f641763552a24ac973d4606a47ff4bba463dbb5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61073e4fe4f4ec2b29ef94ff9034e9c19ab0aadc431e70729510ae2a401ea9a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "966b6f7aaf2c82186c38c52351d5c7cbd0957784cead5947bd3128a434a5e0ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85c9356e595a2177c3a9a2a87f795af747282570f1bd334b5d9122e6eed91c82"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff3f0c71741ed15785896b4ed4a96d9a3b8bf5b6decfae07b88c0737f64315d8"
    sha256 cellar: :any_skip_relocation, ventura:        "f96a4873873cddc76df4d720b4dd5bae826a7d62704f472ebf1fede22d1a6a44"
    sha256 cellar: :any_skip_relocation, monterey:       "ad29b7587789a7d9d06dd0a138c74d1d68b027cb6310f6905c9cbe05b3ab3ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "692dfcc884733b7d7f87d885dc641a12ca12090935960b304bbb074a3b208cba"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
    # `go` version is hardcoded in Makefile
    inreplace "Makefile" do |s|
      s.change_make_var! "EXPECTED_GO_VERSION", Formula["go"].version.to_s
    end

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

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc ", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end
