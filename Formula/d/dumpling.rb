class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.4.tar.gz"
  sha256 "373e8f8b55e99734e60655d2289fb4214a0f686d09eb38f100f5b0c5e401ae75"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6ce05122b7233590ee9fd45a408fa9a1c22d5e3a363ba30580a1a6d3a7bc14a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20ca88a01f70fa8730fcc9645c69e2c0cebf1fd4e7158adffd5e8e41fdadee2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c100b7a130e852b1b1305dbd7d9c1148eed008cf4c85820b017ba7dce977ea8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f2fb7cb43c4ff86ce0c77c5259eaeddf5e3c19fb58c519bf16a1b605b013d9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba6ef82428b56bf570ffef965939860e6e461069f027bf995aedfdc8006b0988"
    sha256 cellar: :any,                 x86_64_linux:  "2cc5af786e4eaf3a9407b65bac791d0620f9e36ab54c4692d53dde7f2cc5d885"
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
