class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.21.2.tar.gz"
  sha256 "4365865a5a938440b2827c568221bf40a81d78f0d4bb35080b1ca9feb772810a"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/liquidata-inc/dolt/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "396b86d6a0dba3b166d03e80e7e1fb39c2f709c5e00379c825b48a02105f4ba5" => :catalina
    sha256 "296fa90f065850bea7a4c32305efd48180e361b59a30d37165ea51e80385efc4" => :mojave
    sha256 "2e2e580ebe7e68bf3f07840557bc56e30721702767ce936ccb8e0c571de8f098" => :high_sierra
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
