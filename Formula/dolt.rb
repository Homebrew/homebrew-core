class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.17.3.tar.gz"
  sha256 "3fc301815bc528cb6f3f48ea05f29102c68730725ab2fc7f87f35b8287ba5817"

  bottle do
    cellar :any_skip_relocation
    sha256 "72c35778b9dae540fad52d9d41d0049a81b0bddb7698ba8d143970949fe5c885" => :catalina
    sha256 "6d94c1b969ed12526ad7b8245bcce75a4f75138fb9479e0ab9ab96f6d1ca67f5" => :mojave
    sha256 "434c0906d28585e1b3b7bea044210bee3fd66c16f0531d9a4d900d55e9c1b6a7" => :high_sierra
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
