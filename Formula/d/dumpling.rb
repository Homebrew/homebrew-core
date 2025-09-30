class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v8.5.3.tar.gz"
  sha256 "432da5f829c36ae1500a9e5c704d20e456c76ea7fb9278e461b74af15e15af2f"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2ea11dd867898817834b0068ad0d8fb1008dfb50920f5c3f145d0d649f66476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36ffd9dd78ff7a73d98d7bd81fc4986219134cbff0650aa5738d17a24592c8f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "313f002fd020feb0719aefae618b611937057e24fd7f19c6db8639a183b1fd6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8de2afed51ec376b1cb3ef1ffc78db2cf181a4ed35d954fe9a9a948e1ec85a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f9eb8c810a245c45ee47206633b86bc25cf63df545bfa3814c1971638cfa7e1"
    sha256 cellar: :any_skip_relocation, ventura:       "7eafce1c31d976e377c95c39915394ed36be6dde597ab192063a678b2950ae45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "792eb379763c2c4fdffe2f7983a9ddf80921128fda04cb183daf2b9967c84ad1"
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
