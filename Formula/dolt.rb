class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.41.1.tar.gz"
  sha256 "df7b8acf7061f6d63031da4d4e36b3e9e2526256051372b6f764ff0476e200f7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "659957026ad9dfd64c30310d0fb15a7ff5506b00a14340d49d428c2e5ad9ae68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a6ee6946760b9faf6b47eec55aaf74db57c13ca8bff1a6371a9272621631b87"
    sha256 cellar: :any_skip_relocation, monterey:       "8518cbe23fc3dafef901a51a67602a0f274ac2a6da245c834d429b9f16ec3963"
    sha256 cellar: :any_skip_relocation, big_sur:        "47b87569c882a137c62cd30bfd219e23a115d75a85dec8c314e8819fdecf6007"
    sha256 cellar: :any_skip_relocation, catalina:       "692ba5bac537d92cc737be9a30ae747d81173e1fbe3df50aa255537a28550ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d2abcfac99b19b032779f8f15fc5d4acbd0f52f951b65cbf25ea78de095c27"
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
