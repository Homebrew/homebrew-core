class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.35.4.tar.gz"
  sha256 "0582eef35de77460c12edf44dca11782b7801e381dadfdf3665489ae6dcbab22"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acaa5b23f9bde382658e32c4e8d04fd39e55ccfe833069ac3788f36b42b8769d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07c17175670aff7307b2bf6d6add2a25de4fa5990a13b97a82ee75acb0ee43ca"
    sha256 cellar: :any_skip_relocation, monterey:       "314666b5149ca3ed7a0a3782251c485779adc015ed925f1bf05d0d6210123ff0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca3cad75ec5f62a13819c5eff3c75f2d8b2e2ac83d48d6310078b73640cd76ac"
    sha256 cellar: :any_skip_relocation, catalina:       "829eac94454567174ae8e8f58b49934542ea00769d22b5ceafc9593047ec79cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a2a3661ffbd4b93073bb3c79a14b783475dfdcee82da0c067f297471ca49e85"
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
