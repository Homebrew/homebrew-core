class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "6f865ef2d25b1bfe250936d45f65cf64e1b638b3d718fc0595e64f2da35daf56"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aea812b0a9e30b8f6874ab2dffc90e977d08b74434447a8767d8e876f45c0590"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16d258f1821389bc9981d133b21f6d62eda30e8b6fa760e7f0169b33d7c2e005"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3408543a833ec5b87f492b6d008876bc8e82b1a70ae62fc2e32bda17e98b32d"
    sha256 cellar: :any_skip_relocation, ventura:        "9455bd4e50d140b5789c2286573353c5c9872d8356bae6915f84f99213052ee4"
    sha256 cellar: :any_skip_relocation, monterey:       "97c2eccc66cdb8aa3633e252816dc3891ca46ce0c046510c6138e40840041452"
    sha256 cellar: :any_skip_relocation, big_sur:        "418cc5b4680eed400d6dc66975b35c4af4cc4b93676890cfe5d829fb35f8cb9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af83945c1cd90c528fcacbe80375e046ccb6c198e5f077113771825377480454"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=brew
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
