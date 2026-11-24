class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.25.tar.gz"
  sha256 "af8c801c0149cfbb129f7b9dfadd333915b00b24a1055ca41262be28c585a6a6"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "79fb72e0543d57b155569c6c6c9554b8c3a5a7cfc27146e21d78e1f1d82ea868"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a5f0d2c8bf89974e502d353709ced4ae50f281550f494686f5e0a5c0b349f7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6a67294bdf3c734b5182cab41555fc7198b8402eac35702e067b6d56d6fa680"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c54aeac0a9141a0ea8bd373ddc0c67c872367decacc7241534f79adadca84fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bfaf9b48a838cdf5a2262a6660b8d58683f2d8679aa8687f5c78ec903645a678"
    sha256 cellar: :any,                 x86_64_linux:      "621623b96fbc361f5878d3ffb24fc91355aaa96ff45e1c5424faa8466c487ea7"
  end

  # TODO: unpin go@1.26 when dumpling supports go 1.27
  # ref: https://github.com/pingcap/tidb/issues/70069
  depends_on "go@1.26" => :build

  deny_network_access!

  def go = dep("go").to_formula

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
