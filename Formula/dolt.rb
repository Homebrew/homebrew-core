class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.37.4.tar.gz"
  sha256 "a6c6b7a15868e55df8fc40afbc5a7335b426e3dda45d665a10b0fdb3fda911a8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4ed52abc7f0ad934ad04f68f78ab54e46dabf71171df37c2b8bbf9635f889f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ba90ce44c95d5d78a6461fda3477bb70fdb41a911026d3b46c93fe55d479803"
    sha256 cellar: :any_skip_relocation, monterey:       "27223a99145f3f82463f2cdd1781a690ba8bbf226132b2932707bb93a3a7fa50"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa8a47376e16c1ec49bf9176f8e50f8bcd2e7e04bbc563a28666380c850f4b38"
    sha256 cellar: :any_skip_relocation, catalina:       "a91f6174c67a9dc33c35924034e56f9a2b7caca78718123a6c08c07188d478ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eadb590aaf1eafa415efda78c3bc1a74e9adef63df037b3528601f6494692cb7"
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
