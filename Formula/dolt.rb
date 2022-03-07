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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da421524e1c212f635b3413991eae4e0f774fc5e8c2892d410149f4de9b155d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e67da4a85c611503512dc2942a0bb4a8eac97962242b1e1c387dc5acc124c38"
    sha256 cellar: :any_skip_relocation, monterey:       "cf45f5c0bf6008642729715abc42cc1cd6016a24d0330cea792a10f9bf62b8e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d127a534e88803e62d19a4283d96238d213beec18b93f587a153ef382630a64"
    sha256 cellar: :any_skip_relocation, catalina:       "4634a8be6d9f899a8aeee2cba884da12f5b690f5ac18ef37a9b3af1c2fc9a60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b1e4e921ad95965635fbb8a9841f9b7b80ae255349036f83ea9e97cf46d777e"
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
