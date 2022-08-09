class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.23.tar.gz"
  sha256 "f9acd21ecb6ca43add80cce3c0bf5f5b7f87ca3067b912844d859619c8c8df5a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4664f9cdd26f9d56418e0d411d039725b32ad84c2b514885be3b4caa9101612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bea64b4cd799e00deb324db4a9d7e1285fed5f093b12c3da721ddabed6ca52a3"
    sha256 cellar: :any_skip_relocation, monterey:       "981c59f70b9049e01201d3a341eb38c319864c3936c28f0c854021189a3f3548"
    sha256 cellar: :any_skip_relocation, big_sur:        "63369e9ca795ea2002b27b57f69cc932b5c533bb625f5c82247b4caa3c58b547"
    sha256 cellar: :any_skip_relocation, catalina:       "81f15d5f615fc198131732da1ab5c30c4eb2abfd4c267af6f177fdf33cc48342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9327d7a455397e79ba38068d30e3d716091280c1b5a5927244fdfde1884fe9"
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
