class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.26.tar.gz"
  sha256 "321b79b1a463ebb3a018b7938e8a9313fb976f1d90db0394147cd1db2cb0360a"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "1193f8142f92c9b5f1956e2a6abd69810466634fe7b0a8e70adf28eaecc6b66f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ebf6285a1a38d4af0037dddcf13c44a4c5fee01464b8663c27efe51602a3134e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "390832eeece24927efc144623dc33c082ba7d4407c716bf12b8aff25e9a036da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c1384d10b0dfd1399d662c04869793e3b5167c733a71766436cd2008ee8794e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2cdf06b6c5ff0dabe9796f312524bb9be9b10ec54deed4043905500f23324b19"
    sha256 cellar: :any,                 x86_64_linux:      "c58722915f6147e4ec190dcc1bfb23aa6a45e6ba9e7aaabb2d453ca18923eb7e"
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
