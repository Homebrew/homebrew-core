class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.35.2.tar.gz"
  sha256 "f3eed4808a9b332b22f190902409a4ee7ef7a339740029cb3d1f0f18a0bbf2ae"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "896c37ae224b7fcb600d0a311f45abee1ad85f31af71e2daa88b6e5838c747ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4d1293957a68bc977d6f72ccabc4bc9859ac526d61fdc994e6b4f83a2569de3"
    sha256 cellar: :any_skip_relocation, monterey:       "577f1f1d5db1736da0e50792284d2e27a907dabbabf9b3d579cde00dc526e0d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "733b9f2285731196e984a020b763dc065911b3945891f38db7b41350cb55b243"
    sha256 cellar: :any_skip_relocation, catalina:       "c848cfd70b123befd5f8947bda466bdc2b7e0aede09acc3860dae922355fe423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7453e92a430c7d83d40e0c92533d413e3680e04a4b666de1a244211ade55bd"
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
