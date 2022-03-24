class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.37.7.tar.gz"
  sha256 "0ed82768721e1737782946e7be44ac2952c6f7e7818c25624a8bf11de7abcdb0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8efa0031cd68ce12d6f3b34ebb3aa8a53e711823cdc4634e6aa9d32a86229070"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17c6c2a7d90cfced182399781526f7d7fe9bb876ec059476bdffa7b4eff2aa12"
    sha256 cellar: :any_skip_relocation, monterey:       "7a1a0be9311bd6745bbbc80db742cc2dd1746f5a3e472b7c2f8fc01f2efde8e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "99664aeedb6a4c04f0d81897f5d8a20a915b60fdb9919a89f71b1beaef6bc2fc"
    sha256 cellar: :any_skip_relocation, catalina:       "f8b97b984896dd53b541d291cd9b8e0f0fb6e48097c4eb9c67feeea7ca11a55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "898ffc31a3813d30e614336e2a317c16aa3c789c02b7a66b80fd34552a4d2ff4"
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
