class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.10.tar.gz"
  sha256 "948cbadf6de867fd150104e8df9aba225e74075f45b5c0424d0a0d8f48d90a18"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcd230567eb8f0cb2d9b0e3f75cf3f19153df6cfe270128011dfc5f893504a55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f416eb061e8943a0e53d5be1ca97be8c362a844c3ac158e4ca81fa3168e73818"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a1567c34c86d465a710eade45b58a687703d36160af9705e95fff21e66e85e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f51ce320f8f298d75b147bf49281822190a0eac84c4f3078132d8e811ed433a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9462bd19878d302a827be5bd55164bed5fb8cddcc1956d735ece8f05ae82b16"
    sha256 cellar: :any,                 x86_64_linux:  "0b8460f873d54c893405bd1fc1efbc2e6893632d06c47b73e56dfe28b7485b87"
  end

  # TODO: unpin go@1.26 when dumpling supports go 1.27
  # ref: https://github.com/pingcap/tidb/issues/70069
  depends_on "go@1.26" => :build

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
