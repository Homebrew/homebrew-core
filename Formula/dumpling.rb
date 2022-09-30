class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb.git",
      tag:      "v6.3.0",
      revision: "ecd67531f1721d3e49eb15a202ac7c0ae02291ec"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89785d4db17432195bd49b946a7a2e50d256cc48321bdf7f23720f11ef9b0c0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fe907de32dfd23eca7a07ca3a8636c19688e7423527e7dc4362a6e745984d59"
    sha256 cellar: :any_skip_relocation, monterey:       "e63f8042accd4e543d1b830f7f4dad74b7fe007c7eabf14c5020a56bc1c78297"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6c305e7415f33e90328c60a19239ee1d95bef982a2a122e52cb31bb6c2af154"
    sha256 cellar: :any_skip_relocation, catalina:       "b52f7ce5a049069f6534bd3a7a6ad89592e28504e13b7d52c91920a0652d8efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fefc699fe136040b68cb18c8c8ec5cb13c9b970cb469d3af5c49b2a022b054f"
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
