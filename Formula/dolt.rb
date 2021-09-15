class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.28.3.tar.gz"
  sha256 "710c2b6a0769c5f445aa009f385d11399b12bbcac760b330f430276ae6edfc3b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f96aa0a102f3c4eb641e91fb197b53958175a8f3363da87c3406b4ae0cd92760"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c9280451b3b6018c72607de980215c80359ebd83509b8f05e04711711231757"
    sha256 cellar: :any_skip_relocation, catalina:      "912a739dc6a8b79557de756d642358b3c1884d0cb967397c3d211a9e0cefde74"
    sha256 cellar: :any_skip_relocation, mojave:        "30ababc8f6ebd81f3ec8751437024cdc2ce90322e580b1a3f39b6a09b069d157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b39f63cbc68116d616f7d34a100fbaab03f5991bfef5f12741c9bce311865fc"
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
