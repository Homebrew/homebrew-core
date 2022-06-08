class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.6.tar.gz"
  sha256 "d6e4b99526f3f1d4b4068fe1a6e7a0e5e09b48b5a7c025bf128683414af1a757"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deec8a4848b174ecba9823d8ac04f94f51de24c87f06b2bf551c05472c49ebfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "258ad182563e8b993b5aee42e93e0434142bd32f3b9d7af65b0a371e6b6b4e79"
    sha256 cellar: :any_skip_relocation, monterey:       "11289823dfbb5114d4a9e40c09edbbe44d5d2ac9c805eb3bc7e73fd1ee2ef67f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec2cc09192f26c49933e0bf59ca0e4c3a7c1ca68322b48dd2c81e5471a3869a7"
    sha256 cellar: :any_skip_relocation, catalina:       "aa61809d3e49705807ef0156923554d7d593a599032af2a81c07060f4403400a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "933e4d661cf82821926053806acd4b821507c3907f6ef5788f98d7ab890f7f39"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
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
