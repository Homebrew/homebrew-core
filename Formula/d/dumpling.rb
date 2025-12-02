class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v8.5.4.tar.gz"
  sha256 "ef4940cd0190bf00a5ca5d1043f53e53f24ca18e582a8a2ae5bd3b9977881d04"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3c14ecaefe7fec8858948789a25562b4e607425b4d8fbf6cc02022a527822f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00c597d949826b88baed095a14903e8c856087b77bfc19343cf4244c42c45e38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3afe22a7c71772813564e4742f1557e1bc441f411ab51a606f6003d0e98d7449"
    sha256 cellar: :any_skip_relocation, sonoma:        "3890750570b2c7d61aa5f545af85fd1ac2680be5d81657b9344a86dd1c6f2ab9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41ef77a2e9968375326c10973df5d9479278cf6949254b373c80aa77fbeb0a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de06f401312642d2ee9b822c0305da0949f5b490c03b801941d43263ed49d38d"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=#{tap.user}
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./dumpling/cmd/dumpling"
  end

  test do
    output = shell_output("#{bin}/dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match version.to_s, shell_output("#{bin}/dumpling --version 2>&1")
  end
end
