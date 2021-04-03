class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.25.0.tar.gz"
  sha256 "f93c1e994406e667bdf39570f08b2bd6c35d73e0b7fd76e24c081c759dcfd188"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dbaf36902480942eb4fb43790fc5460a45972a4e498b4b2cc102e3484f8b0b8e"
    sha256 cellar: :any_skip_relocation, big_sur:       "24ffeeaecec8a5197c2bc8b571d6ab98859c9f6e326ed6f1366b73d23aa4659e"
    sha256 cellar: :any_skip_relocation, catalina:      "9ed078048dce427720e5c7412160372197f3b0575c6680a26c76d9d23f6a9b80"
    sha256 cellar: :any_skip_relocation, mojave:        "87b32e0f2041a479f64e204e7cd00fd27bf2258f70f0a26c4db9fa8bf7fa9686"
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
