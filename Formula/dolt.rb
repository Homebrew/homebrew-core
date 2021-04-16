class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.0.tar.gz"
  sha256 "2239ceb95403f0c4a0efb63d423636e19ee8c0f7f4ec0d1f5be8e3aeac995292"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bc8dd62c305a68894dfb96dbf7410cbd1455fbb2efaf9436709da25a087e115b"
    sha256 cellar: :any_skip_relocation, big_sur:       "043c2bfb7a5232061a3835069da9cbfb19563b640bd5db71a2cb779489c6deac"
    sha256 cellar: :any_skip_relocation, catalina:      "2dbca5bd86b0847e959b40c992f8587ddf82a4d5229874dc649a151ae19cac8f"
    sha256 cellar: :any_skip_relocation, mojave:        "72172f6014012f5c08ef58c11009bccce8468f965251907dad1fce8ba5916eea"
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
