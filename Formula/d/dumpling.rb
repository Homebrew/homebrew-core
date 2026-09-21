class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.16.tar.gz"
  sha256 "6eaf0741f0291673254d38bf9437419f9ff9b6c193910da282b7eee35e0c8cb2"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2e3b147e1d57fe11d1a2fa000a89bd80aeb92838fb911c311ddbd812e8bf78a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2132c1073cda8ed9bddcac0c2230194dcf51977f448c7d6c8f953949a2a58a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "873fb7d539c0ceeded8e35d96f7a8cdd9d919abc1f7d0ed950d678d5da9e92b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "427de0ee9056be8e9e29b3cc2ee09738664fd0fd55dac1a2136805cb761884cb"
    sha256 cellar: :any,                 x86_64_linux:      "c03911150fcb62f39711866402a5612a378654b9feea30e4731dff5e89ca4def"
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
