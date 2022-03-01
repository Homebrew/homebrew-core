class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.37.3.tar.gz"
  sha256 "ef42f9f688306a732aab2aa96a1aacf5eb688cf9b6c73044d710d91f4c7f5b2c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c298eaa8fba16666c428732ab47d84d8b34f8694c17a34b6dc963736a0f2dbc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dbdda01cad263bab032701a06467f54a0d8e5e232c1008bb4fedd14c7c09cac"
    sha256 cellar: :any_skip_relocation, monterey:       "29b14b1d73c8a501c196a318d15909e76ae173017b3cef3d3f0b11beba660ed7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b283eb71a926eba6f1ab7aa8c36515c773dcc80e96f363ec6c5ba5dd12897279"
    sha256 cellar: :any_skip_relocation, catalina:       "be8b760a207978bd15c95a31fc4212045c2128c2279c714bccd8df019053f1cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73a055a91819ac302a900fd36de4d1efe57b40eb2114a3de3ffac1b349962c6e"
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
