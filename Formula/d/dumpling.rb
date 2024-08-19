class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "876bf565b7c7fe7e539098daf264e5b699652da5337c07db87a1b5de270c95da"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "117e97292b4cdf130f5152b9e2f636c21f9263df5f317c0d33ecfdd145731a45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c255345b059fca1f3589cafbb402571430a4c2c29d4da38bc697245d0f88a46a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc357ca5c8f7bc263c2e144a509106b13ad67896918bd59576964810899b9b3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c0c12737f05ef7df4eb5ccec8f29856cdf9e5458f753ba8fe0efc5a5df31e48"
    sha256 cellar: :any_skip_relocation, ventura:        "46669150a27ecdc0f1d4ec5d3de779049cb9528ee24a3e5292421ab94a92966f"
    sha256 cellar: :any_skip_relocation, monterey:       "799f35a609f0488fd98cea6866cf0fdb54f19d9af276d1a1c192d11d8e04081d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2102c86da73c336050ebbec8cc36b05c07f2d6d14f701e9123f43b567b192ae"
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

    system "go", "build", *std_go_args(ldflags:), "./dumpling/cmd/dumpling"
  end

  test do
    output = shell_output("#{bin}/dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match "Release version: #{version}", shell_output("#{bin}/dumpling --version 2>&1")
  end
end
