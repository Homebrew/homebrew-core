class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.36.2.tar.gz"
  sha256 "4f37bbb1ce07418855473a3a4938127c3b191eb5a308ec1e1588027db7a128de"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0428be85e3bdd5a6675aaa47c76a389ced412e42be8994ff1852c7b15a0c6372"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e93fc39484505dab73b5d6bbb6965b100298e086dd337986d4f2d42ccfa1e0f"
    sha256 cellar: :any_skip_relocation, monterey:       "4764cab6103bd7558c1bf4d71066406cf794bc6c65edc1903b93df89ba3f54b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6239a5df6c93c456cd3a5d73e3d7c8ede87ff50d63095fe074c56a206dd5c4ed"
    sha256 cellar: :any_skip_relocation, catalina:       "c3478e4fad1e5b70553e4c771cdb5a89743a4542376a260cde1c52e5885e3e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64ada13f318ecaab67259c68d052cf35e7d5223445f1c5b312dcf93dcf619b6f"
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
