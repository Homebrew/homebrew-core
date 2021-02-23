class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.23.6.tar.gz"
  sha256 "41caa8529ba396c6b55c939e5419e680397b95e4015d7efb02d13e3bca90ac30"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b0413cb20d31003c401e7bf6bd2aa3a15a384670a6f369c51f4633dc703dd67"
    sha256 cellar: :any_skip_relocation, big_sur:       "b6be90afed77b425b37fcf76747eec2c41d861856d8c9955d91955673627a138"
    sha256 cellar: :any_skip_relocation, catalina:      "2aec26a00e6f381ebb5091a78f6c47f0c6216364345e0e87a3afd3361c5747ab"
    sha256 cellar: :any_skip_relocation, mojave:        "e2cb5ca67f3764f791d4018fa7ecde1d9528c0d5315c847c0c38fa97c4bf6725"
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
