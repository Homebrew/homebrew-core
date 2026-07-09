class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.6.tar.gz"
  sha256 "c72ff98d9c5fa45e2c72b9ebfc7ff849f077494cfc8e3edaef84779ad9e641ef"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "863f0a291d496f7525723d3e5505cce0fba9e050eca6af513f2d411b02bebea1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d65f909019b22911df1b7b508269ab6781caabaa235eb14635098abea2f4e17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a34e26907c877b8fab6f4893c62a7c9cf3212a97349b10f071222ce95d06502"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca057214634a3c47061ad2f071f35bb74c4bd202714cc57897b76450996848c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6f7b119b0a407aeb35af8a83d87a4486c0f9ca3bbe04dfb89cbe02d02e30d2f"
    sha256 cellar: :any,                 x86_64_linux:  "d6f2c96799babccc95751e528d0b6210f133224ebb36bf7425e14dff41371da6"
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
