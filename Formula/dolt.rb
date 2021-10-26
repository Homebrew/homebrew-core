class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.32.1.tar.gz"
  sha256 "5fbd54d1cd0e6cb8ffc0e601644b245acc9cd11ea2da81a9862d0497451ffb05"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "448b4d4e9c50dfb4de8a445a0896c76fbf857e37bdd7d83b86d42b06b7c555ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d323da1ecdfad79e429726736da487c574e997a0ab6602cecbf2fdcd9f4d6bb2"
    sha256 cellar: :any_skip_relocation, monterey:       "9ea299c758208d6fcee68aa614aee524882bcff83263a2aa4070f5c9a5bfb170"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e0201f4fd6f713c6c7aefdfe951b2942c2752ec7229b3902920b2e2bb2744df"
    sha256 cellar: :any_skip_relocation, catalina:       "71e3f8a422076b817a07bd3f5fb90f17d640d3c6d1c57fccaa8585c65ed27a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d9b7c0b442a86fd62f2853bd5cba55c8aeba74f04c6bb9c64bf8d411c8de528"
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
