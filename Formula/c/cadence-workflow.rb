class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.14",
      revision: "51ca977369869835e3e67954aa15f08162963b0e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a919ce8f9d62a4eb176415d36c4852c62d8f02bf7d21b19260b85c860b8edd33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8635ed6f308ecffc6fb6e50e234e392afd654de58ccd02a24d9e6e81a295c8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "614f467e4d1324673773628990528639f101c788a1f883bbe0e3bf965ed2a931"
    sha256 cellar: :any_skip_relocation, sonoma:        "44f29709a00103474be533bd67c74edfbbc5557613cdd65b9492ebbba804189b"
    sha256 cellar: :any_skip_relocation, ventura:       "092779dff66b7df76f892520e7b9ec51e78f35c35c641c7958ff7caa94687254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "284a0ae4f7d1fc34866c2b79a5a7212b3cc32b424cd1825a0c2950d9fc6d5401"
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
