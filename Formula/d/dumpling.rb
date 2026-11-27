class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.27.tar.gz"
  sha256 "11153383bc78f050705d6a8300e03ab47139a0e5de82b4c79ea6637855356cf1"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "a916ec6a71d9bceb00f0270b13598546aa623e4e265722a2468cc68e674395e0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1192341f57991527038da41e002231f4456d45760b0a7ceaa8242927f50928e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8db08bf7f77ccb766d9134d3ce786f7e7422f39f4fb5edbb49f0eaa8fe5e3dfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98737a757099191ac00396ee70db9e9aa73e41f2ae050d4951f8b6ace8b7f105"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "681a1df6935868ceb89a60bc0317295e5202d3a481fc5bb60a8ceb1ba348651d"
    sha256 cellar: :any,                 x86_64_linux:      "2972b38e0d11139eeef1fb71bf38cde26e24ba2b90bfa9e748f528485d9aaaa3"
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
