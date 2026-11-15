class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.22.tar.gz"
  sha256 "9bc4d7701064e0d66e4f400d5c9bcfce318da788ee9bcf1802588b79798d0da0"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "424755eaaa8653442371ef2085845502ee7a7d310387739d26ff75c0729ba5c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2aa9b28fc8634d2a01765abbdb706d608933cd6ee1517ec42b0f0b8ec1bda60e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90baea5f7c0b26efeea7fdf34e1dad2f628c1bfabfc3674d4f02fba2990d5c98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5ecff505514e347fad845ba590ff4d2b3d0d1e2f5fb3b983cfaf378b981c85ea"
    sha256 cellar: :any,                 x86_64_linux:      "094e3a48ded10d0fca99f4a1b8139ec4f45b1f3a0a8ab2271d3126f0c95dac2f"
  end

  # TODO: unpin go@1.26 when dumpling supports go 1.27
  # ref: https://github.com/pingcap/tidb/issues/70069
  depends_on "go@1.26" => :build

  deny_network_access!

  def go = deps.find { |d| d.name.match?(/^go(@\d+(\.\d+)*)?$/) }.to_formula

  def fetch
    system "go", "mod", "download"
  end

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=#{tap.user}
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{go.version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./dumpling/cmd/dumpling"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dumpling --version 2>&1")

    output = shell_output("#{bin}/dumpling --host does-not-exist.invalid --port 1 --database db 2>&1", 1)
    assert_match "create dumper failed", output
  end
end
