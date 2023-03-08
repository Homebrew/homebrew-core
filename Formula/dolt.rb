class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.0.tar.gz"
  sha256 "b8fb976fd38afa3d19e853050ec995283d0fa33e581a3ed12fd034d9f3d450fa"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ad9fe162e2d4ca904210d60be79c214a64cd05d2bfa96cc28e8935a09f1f300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ad9fe162e2d4ca904210d60be79c214a64cd05d2bfa96cc28e8935a09f1f300"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ad9fe162e2d4ca904210d60be79c214a64cd05d2bfa96cc28e8935a09f1f300"
    sha256 cellar: :any_skip_relocation, ventura:        "a6ff974d696e80b4a698d5a771e0d8a3e58c5f583ed35c4c2e68b24e6ed9746a"
    sha256 cellar: :any_skip_relocation, monterey:       "a6ff974d696e80b4a698d5a771e0d8a3e58c5f583ed35c4c2e68b24e6ed9746a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6ff974d696e80b4a698d5a771e0d8a3e58c5f583ed35c4c2e68b24e6ed9746a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "247e4c55526e3cc41525f351f320852095e6c00bee788d4ac83a75ac99158456"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
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
