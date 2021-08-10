class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.27.2.tar.gz"
  sha256 "6792eb54ae87f3984551dfe2c3a15fce59e3a7884b730cf0daa9011c0f043372"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1576ac0e2546b5d5d24e7b134abcbd6fed2d6f8f64ea0be6b83dc128cf71b64"
    sha256 cellar: :any_skip_relocation, big_sur:       "e6ed72f501cc1ce16566deda161f25890a613bfb04a4a5cc9b624e36c807b707"
    sha256 cellar: :any_skip_relocation, catalina:      "66224416ae373aafc46d4f1355c080dcbb562e7ebc55294a1c86fe0df1a3c805"
    sha256 cellar: :any_skip_relocation, mojave:        "77db2b49c56ec6707920561c566c01bb5043d547ba9146c33d9684a8f601eb4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9441732ba4e5a6cb5f97decbc50ecbfe32c03a20567b0e4e387d3e1fd33647d8"
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
