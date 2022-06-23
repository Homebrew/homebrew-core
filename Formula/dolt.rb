class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.11.tar.gz"
  sha256 "b145e7fcc9abb8d4ce71339da2f163c5922ea387de5bb1a98c31f61902fab786"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f3f90a49975631ec40bf919be7a154f620cc86449ef621734f86e8c0baf624"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53467b54e7f442b67a0ea5de84b20a4ad865a9f6d5d6dfa3cf2f95788679f7d9"
    sha256 cellar: :any_skip_relocation, monterey:       "49f85108a3555b3988d7631c6961b5d33bef26ca206d9cdacc0de22424f5ccc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "862bddc1a3282b2d7b59b7ffc26ebcc280f0c6ba2fc810cf6d007641a5541929"
    sha256 cellar: :any_skip_relocation, catalina:       "83333b79f889755495e2bbc17b8b662604ae190324e8116a627d86232daca3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b49b70453964378a40142253c5d9f3082acc627ca327058f6f201c5fe288f37d"
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
