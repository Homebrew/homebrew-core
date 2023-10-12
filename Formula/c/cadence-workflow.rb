class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.2",
      revision: "e5f605c1d591b47856c8e0b6bc68bf235de1edd5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "312dd2a1158b980993cecbad48d16787d2a56941b3a67de2a561dd0ef43992d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a429586d9fad9999318fbafd836e0ad9c69aba88785fe827f2386276328ab477"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "630520603e244e290f6f30ce7fe29836d3a154088ed1bc703ed94ad3f6c577b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c859baeec0700524715c81b7d39a33e0512dde17410dbfc4412ab6864209c8b"
    sha256 cellar: :any_skip_relocation, ventura:        "722da6102b54c7d982a74592cd97da4cd0970e7785f9d962576d22ee3f17bc8c"
    sha256 cellar: :any_skip_relocation, monterey:       "1a3ace1dd68d14e3689e30a77ab88f970239258944fc82c819b38c1054d46b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "187a3d60bafefbc05fa040b5f2d61fb54d50a17c6c609d20a93f371db99fd51e"
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
