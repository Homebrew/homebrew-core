class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.27.4.2.tar.gz"
  sha256 "c22431b2efa0fb50ae8cfb40f93ea38cc61ac6b65bebc733a1fa1cd4d4cccfca"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "388f9128e446a203241c64c760ab18481bdd7dd38111aefa75d01baa0f6f2a20"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c62f2f173319afc8130205c6b93b6384ea815066f4d87118b7298f78af9e0f0"
    sha256 cellar: :any_skip_relocation, catalina:      "e089392843a7e3f9f4428e7a4edf1989254da4ae5e7716424d2f539458ee2df7"
    sha256 cellar: :any_skip_relocation, mojave:        "ab6d414232c112ae8df6ecf1f0c57bf22f9c619dd196a9e816e241443cfcd9d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b23c096d966fc55d422397a4c6d3e54d15788037d875788eef0d2926e661a98"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
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
