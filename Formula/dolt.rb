class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.16.0.tar.gz"
  sha256 "250d160fa62631d51268a01cf0739c50eb7b17ff5e735461352e659fbef40717"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8aec17c86c07921b9b4ac75a4ab972a11f7fe546f8298c9ef5a7b01b7957da3" => :catalina
    sha256 "b54c39582eaf40ed498d5977814114e0759fe6bf298ccacdf503923c87dc6e12" => :mojave
    sha256 "61437d16d9182709086ab88b480e7f48dbcf8417b8f52185aced8dd2f197b876" => :high_sierra
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
