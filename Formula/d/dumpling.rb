class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.24.tar.gz"
  sha256 "77b8188d863d48e2bd62dfaeb1142a23654f9db639530b13550a9d78c61ae122"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c572d039cd47b15f148ff597708d2fe565f44c5a264758013b9f6a7347e737c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "663a709e309066cd62693518f994ffb504cb9f45421c4ba89dc710c34bdac164"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07b25bdf3636356dcc007ad34b1b4a7d66b8fb475b4fe214ba9aa262889e612e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b632ba7a2bcef7f6477c44bb8be1a1c004aec5107bc52ccc580c04e6ea03d118"
    sha256 cellar: :any,                 x86_64_linux:      "d92ac888526a41dad11f620a8971e279e25675d01736ff84a55f532a1f0f39a8"
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
