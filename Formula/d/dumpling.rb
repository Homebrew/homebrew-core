class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.23.tar.gz"
  sha256 "ab20677a93df42ea1d0b5247037d93528b0d9acbf0330826c06d19162c2559e0"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "effe5ef6c759e0a6b59dfcb4bf49cea5168591fdd593bed36c01d349288066e9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24a25bb0fc7de69eccf93cfdef5b91e4696b9d2a935ac9e59cf0b8a89cdc43fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ab41d814e7c862641d17bd217d4cb9e2331a70faf26606ede9551c78a478267"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "45103bcd1edb2e97bcd6b57c8ed39ada20c71b093ee3ffc9d72a0f2a94c7da38"
    sha256 cellar: :any,                 x86_64_linux:      "c88c4d6b7ccea8440bba8f0e5a0a9cba33f6ea5d008575a1738bbce626b9c02b"
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
