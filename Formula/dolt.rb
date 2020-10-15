class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.21.0.tar.gz"
  sha256 "788aa1d906d4ee4e93ed576607a971f803b6fabf2aeb7394cf5b2b1940c4a8e9"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/liquidata-inc/dolt/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7307ce20dc309692fea2e5f88e07bbb40c257cff03f3a5b3b47d6ec86a3ecfc6" => :catalina
    sha256 "cfcf20596083a278fa12e04c22b2a1336604a9ddac12c35ab4e120d49ffca14f" => :mojave
    sha256 "d8f5df86d585d9a62437776d043a1f9e481f29640b28bd6c9748dd0af7470d42" => :high_sierra
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
