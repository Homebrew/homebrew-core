class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.34.6.tar.gz"
  sha256 "bb0fdf0c849033f351e1bff5c216d773637e3d73016fb19a260b6c9e1f655100"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "416cdfa98045f88b3d5efca1f3594fa4ceb5f88ec1fac9aaef8b3ecd63c67069"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97b372ed1283cd9c47871cbe5984102402edcd9cac7077b160ab8a91f6a9506a"
    sha256 cellar: :any_skip_relocation, monterey:       "ab10c2185bd62908a389f96e18463fd267245335df5a22f61560d35bd31f494c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ef014d4c26a6249d3ba11b5dcbbae52717130fb425e06677a1d46f7a20fef54"
    sha256 cellar: :any_skip_relocation, catalina:       "ed6ebd174c3702a6d8a2deed5472d2320ec84664743d49938ffcd311f8a1945d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b7d30cef9e30c611e0ad8fb9ad07c1ea9afabb2d95fa7c3585aa0df94c9773"
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
