class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.20.tar.gz"
  sha256 "c9d0de5a6a1dda09ec27afc79a4b91878e1ad11ead40b2317710cbfb709b940c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9333c3a48cdbcaa505b19fd8f18cff93939f46db0c102fc00046e15c026eb2f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10e9f920618653ae7b7d20693bf7c1c4b973b0562c7d9f68c68985d5673ed75f"
    sha256 cellar: :any_skip_relocation, monterey:       "e764ae41357f117df3b4a36572b8639c4f76254b41426aae39941f65393c9b90"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbcd25a343d993de5dc03e23e08f0bf93b077864f43863bc9251233482e5b0a6"
    sha256 cellar: :any_skip_relocation, catalina:       "c2dec0d421cb623594a01cde93ae4d9e42c33842ea59950a38fc9f9dcfffe949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "673b3ce6b8c56b8544a57e7c40cf6318c033342d2b9795314c1183459b2e7052"
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
