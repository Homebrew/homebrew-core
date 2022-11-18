class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb.git",
      tag:      "v6.4.0",
      revision: "cf36a9ce2fe1039db3cf3444d51930b887df18a1"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b920a5297696fb4cf768394848aff6e0265da2623e89931cc39e2f69a58a59b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af8b802f84d8b3a642d09ec6f172f42a3bd821b34c0f60e097cc27f918c0b945"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81401f162ccbaf33706eedc9f457e17be0b42cd337369359f56200392aa111a1"
    sha256 cellar: :any_skip_relocation, monterey:       "7b8b771d507809b933a0ed80dac9da4fe0d3c6b1007ce21e20e02e10c111ce7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7da20f08bf1e5e41a71f66322cba0f815bf03cb1dde9abfd31f51660c46f8767"
    sha256 cellar: :any_skip_relocation, catalina:       "7ca896dd636f45fdf3ffc1c99da9e757ab6441204b6001ab7a684b20538ee9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "279dde18ee0a86471161942a13ac85d78f82961efe19fd30b5fb1f32ded3c28e"
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
