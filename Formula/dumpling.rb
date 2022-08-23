class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb.git",
      tag:      "v6.2.0",
      revision: "daf2b17cdfe30c02ce282361009fb5bdb05f2b0e"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "374bc44b478103564f06a3fcab84fc724c1bb8afd0a00e72b4652f2bfab6ed57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7fae89f51dd36166daeee51c4fe201f315abce3f12b3f4f73c3a5dc8940adb2"
    sha256 cellar: :any_skip_relocation, monterey:       "bf81854cb648de445f99aa87430d52fd2fdd71d7c115d531239c3876f94b9937"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e62dff1556715af8839f7fb17ccb5003f27a8630c5feb4f18ded0d279853967"
    sha256 cellar: :any_skip_relocation, catalina:       "801b781d224e94476fb84125b3a0308399033114a1cb2309cf813f49d73a538d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fdcd5ea7543cb0a6d2720e74cc6454168d7407bbecf2fe6a49ba6b156b9bd98"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=#{Utils.git_head}
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./dumpling/cmd/dumpling"
  end

  test do
    output = shell_output("#{bin}/dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match "Release version: #{version}", shell_output("#{bin}/dumpling --version 2>&1")
  end
end
