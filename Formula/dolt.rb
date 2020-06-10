class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.17.2.tar.gz"
  sha256 "72a381f17d9576d16c3f082cc1eb416bf8940088bb1d124c4b62a615ec0201dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "d34307f7ca36c5c0283dc5f2e630493a4fd2ea5b03d79f7e497383cb7d9cd80d" => :catalina
    sha256 "f6c1dfd80c8176299184fd630c4d2027c88276fc5f1197dca9d15ab95102adeb" => :mojave
    sha256 "fd1085907e033c7c532b75539c098debbf9cac9379d9937579d7c51f8bb8e74d" => :high_sierra
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
