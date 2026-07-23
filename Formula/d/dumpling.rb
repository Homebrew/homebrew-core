class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.8.tar.gz"
  sha256 "600b6e13c1063a01b0c1c614a4b63a2c89fb6f6cf0223bb363255e2520b6eedc"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98f98b93897e41c90b70ac6f7df2ad8c3d3bde1d5c92256a1ca71187a213d817"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49d98e8758873a85eceacfa07cdd88dfa89ae1449a5e55edec82edaef85af4b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d87a94e9cd01cc04b3fc0ba57bb5ab54187749cabe85e06999a5f7202da5e5cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0322a79cd93254fa98d38038db46fd056959c790ad86ce60c7755c0a173f2360"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6e0f0fe62d54053461e42aab84e61c3229123a516d27e1f19430c95e579ec35"
    sha256 cellar: :any,                 x86_64_linux:  "d646132323e02c66e8ee6b411a13279f373e3c94fbd447a459a3ed55600b0da2"
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
    assert_match version.to_s, shell_output("#{bin}/dumpling --version 2>&1")

    output = shell_output("#{bin}/dumpling --host does-not-exist.invalid --port 1 --database db 2>&1", 1)
    assert_match "create dumper failed", output
  end
end
