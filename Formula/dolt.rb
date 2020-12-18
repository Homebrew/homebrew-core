class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.22.7.tar.gz"
  sha256 "3e8c30ed1353927d7f22e415ab4827aeff5653e5a1aa58dfc18876618d68e792"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9b2a6a6735f9399b1e32eaa6fdcb16db2b3c72b751fa44cfb99b7ba0dc7b750d" => :big_sur
    sha256 "5639b74f256feca79aa187ac432126d63b84ac6940c787fa7fc7bceb57fc63ce" => :catalina
    sha256 "2fe15866972a400f16170fc3549879a5bf89f93d5dce2f0d2df181d989341088" => :mojave
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
