class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.37.8.tar.gz"
  sha256 "36b36b3778eb58e5ae6be9ee9718c6fb2f92e2ed0801f72471080ef36141d892"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43179d38a536c635af7cede2ca443ef49f6a6f58afcfa34c51ca048355a40960"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "596db56311e6f0a36babc80065fb61878c222cee5c173cc501eae1f41ff1342c"
    sha256 cellar: :any_skip_relocation, monterey:       "047f2f6c4cd813a45082c4167b628a7e8160dd42a4da3b6901ea4c1a940763be"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cd8329e21d4cee848f1f4cee59d0e731c0f1a33134df03063c718a5a73afdad"
    sha256 cellar: :any_skip_relocation, catalina:       "4d9753ab42c0e4dedd0e6fd6aa8e62c49acc5638d07faf6f9aaf9d1698abf912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc26529347f1b1116684b5e084342c131e9f3b94df312994c750f27d5f07f86"
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
