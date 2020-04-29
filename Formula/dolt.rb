class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.16.3.tar.gz"
  sha256 "c4ed0b0a17b5d42e57efadf5efefef1ceef813f309d11e757deb675c8e2e05c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "22245f0b44172c94c6bcb6d4806632c08f288819caf736b2f4898f4e57e1089b" => :catalina
    sha256 "7cc4b1599ee67beb044a7d6e7fa2e6a0b13faa686967c70b452b62f79e09709a" => :mojave
    sha256 "bb2b822786dc6f31224e8f3f158d9e5b87b916fb9b9ae12c279ae86c2898a502" => :high_sierra
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
