class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.7.tar.gz"
  sha256 "b06f5dfbb7f1f9e18c014f69e2cf955e8887551ffa20dd460eae874a0be2af3f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bb5d88b1112f49513fbc407c424d0065a9564e11b08c797ddb3713bcc96159a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aaa0cdb838373ffe09fea291379a2019248b0623c3b30cd73741bb988335040"
    sha256 cellar: :any_skip_relocation, monterey:       "d2de162094d195ccac591704d07a583f00f2d70de38e137917691aa841ecf9c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3c2c021e7e9741f828d56f35219a6bcd171ff9b6d67e9169b01ad9d784bb062"
    sha256 cellar: :any_skip_relocation, catalina:       "c46d265a53084a59383b54e71d5e2c119c77f3cd82c40087ff112674ab75c45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40a305d8fb70ba56b382360af54287bc94ec14aaf1cc74aa69fee19a79592aaa"
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
