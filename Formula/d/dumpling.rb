class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.0.tar.gz"
  sha256 "f8ef3a5f6d98fd04670aac7c9170c8a0bb0f3a773593244da046e221b6290580"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d8250ba9c2dbb1a383d39229356a42875462a5f5ddc2e4d910b4776f9484374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b702610835422d9a57705ee2eb8a9addbe84e8ec292b8cec9abdada12e2516"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "758f62647dc639f9dc3ccacd53511560fe81a90d2c9f2eedff89ae94bebc220a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a021f74123efe7e6765f39c4bead2548e6269dd556b97606b8ecf6784fc5e221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b11f99e282135fce5589e663b816ff92a861920c432f560a8a1cbf1c89aab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ffeb5b4bcc71ade151f7e74939ac736be7713a4df56110f049a0a8a50176ee8"
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
