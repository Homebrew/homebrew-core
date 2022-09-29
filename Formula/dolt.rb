class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.41.7.tar.gz"
  sha256 "6b22655f915a5265fb94890b20d7c89db7c888c3712a5b424790089dd0dfa255"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fda6a0cc177bfbcb48126eb7ab11a72bd2c29b30d77ea4a3eb6419df7097810"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1af4b308cae86a6d940adce893c4a97bd487249c9771e3f407722fc60a7fa70b"
    sha256 cellar: :any_skip_relocation, monterey:       "31c87a3e5187609dfc7d53234da6a3603af1315557accc265ed86c2800669408"
    sha256 cellar: :any_skip_relocation, big_sur:        "4447e7a268ce50e35b97dd086a8dd462f49732d8768f3a4dccbd911cd412d3ea"
    sha256 cellar: :any_skip_relocation, catalina:       "e7231f72a264a2919d61336149905086ebe8e1e037c1f9236cc9f54226f3aef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3e1e397a997f8a36fdfee72f49802c513d54d4a03dd901751143d7ec5196c04"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
