class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/cadence-workflow/cadence.git",
      tag:      "v1.4.2",
      revision: "c98e64e010409fbaae94cdc19c2e70ee662634b7"
  license "Apache-2.0"
  head "https://github.com/cadence-workflow/cadence.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fbb110c50b629456b6cf9aad1b62c9517c2649ef90cb608249a1be125b0c38a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ef3808218f82f2ca477bf63a5fdd8632df2b311c143712abbae674c1a35ac40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be8ddbf97947234b933537c39a0fb4bb031cec87137effb32e95977b975816e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9e64141df3b423878b273392a85fafc71a58fdd7e5374d63fec62d762629c74b"
    sha256 cellar: :any,                 x86_64_linux:      "b3f4a42712bb86528d08adc41bca1247207b98048cc5f0bef2b434e26f4ee2ad"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  # `test do` block binds a local port
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
