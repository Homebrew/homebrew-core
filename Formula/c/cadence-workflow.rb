class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/cadence-workflow/cadence.git",
      tag:      "v1.4.5",
      revision: "ecd2b70caf1fe9921aca19b00eb0b2905a3cc602"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9652c8cdaf0d32cdfbf81524c3d4e994a707b724a9d2a7eb5380021184d40696"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d06c497e25d8a0cfc5537f659fcd6f7c55070bc76748040c0385442674bc581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a4bbe545636bc16509ca5f70ce70b4fa16d6aa7573bfb5180e35a6d6b2cf240"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba840612c097a477bf0efaa23fdcd1e50ff88a80c9d80553c12dd1f446befbf0"
    sha256 cellar: :any,                 x86_64_linux:      "f0608915915baecc3d1b0c7dc6000d808a7ea3b64e5d3499ee1ceae84ee2d983"
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
