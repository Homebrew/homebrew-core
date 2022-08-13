class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.25.tar.gz"
  sha256 "7df847d03cd97764995107b89f3e4aa19cb500c207dd48039af292e09169d572"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db87f109408ae388ea920cdcca38f82dff3fc1f28143a9ac1d6e985102dbcca3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18e8e1cb085343d16c8f1d9b51f6887e9b9bbee54a585165ab95fbc6b4c76122"
    sha256 cellar: :any_skip_relocation, monterey:       "ceba36504e58d4f13b5443d9de4b433012d89b04c2b473241592f1d7a2a9459c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2d71cd2ab85452c35a6ff8b8c7b92a6419e6a5db4f15f1b384e2d0db4887af4"
    sha256 cellar: :any_skip_relocation, catalina:       "8fd94af7e246524da1c3a394198b7ef4fe52688fe372fa64a2be89ef607c46d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04655c9a67ac910ad2cb44c18f1aeb5c3ee02ef71940e98698e9176c880817d8"
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
