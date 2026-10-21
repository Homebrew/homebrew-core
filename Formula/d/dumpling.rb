class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.20.tar.gz"
  sha256 "7e483091aa8137c20e12d727d1cf459c53d78b47586ae56a0922e3655eb10f92"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "87e75bd9a3ac2e749fb42a48e026b370ac17a3667a5ee1be96331de524d95405"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91470659ea6c3a22db8cf44ca8a0612ceee1dcbde0f9d577a204a8e20c8f113d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "faa2d78a8580f9d5c6eed4c15a7092950105f8a4d2075f8bda4e05bdab4981d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "95ee7766cad85fa0fff7bf37ca1be8680bde898668d775960230cd1fe6104dcc"
    sha256 cellar: :any,                 x86_64_linux:      "72be3a4e72e478d3a8374e2728b7dcbde08f567e36ee0313527d871d4a00b6a6"
  end

  # TODO: unpin go@1.26 when dumpling supports go 1.27
  # ref: https://github.com/pingcap/tidb/issues/70069
  depends_on "go@1.26" => :build

  deny_network_access!

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
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./dumpling/cmd/dumpling"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dumpling --version 2>&1")

    output = shell_output("#{bin}/dumpling --host does-not-exist.invalid --port 1 --database db 2>&1", 1)
    assert_match "create dumper failed", output
  end
end
