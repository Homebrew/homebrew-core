class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.10.tar.gz"
  sha256 "11ac1f1fc095ce09ae39713840ba74a88365d733133b898993693305429c9d09"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9471d93207780e151adc53587d18cc3a66ec42dfa3cc7ab7272957a233d595b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d17f86cc6d01795f33ee9a7116b884fd8f9650264af3b2bd8f1461c3f582324"
    sha256 cellar: :any_skip_relocation, monterey:       "f5520ca479c577c65f8d8de18576dd7db84ef50b41c48f2aa3cbc97cd5bf568a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3b1b7bf3ffefeb709d3bcaa5d17fe54420cffc7aa0432d39f87ce73245fb50d"
    sha256 cellar: :any_skip_relocation, catalina:       "89616c3b7ed714622e4ac0091c4bbc5299aa4bad1ae2ff29563fb75d5d0221db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "352599990f57537eb9240b66d2b1d8cfb70b77f21c3c416a2357cb33aa14bf8b"
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
