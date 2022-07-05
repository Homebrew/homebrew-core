class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.15.tar.gz"
  sha256 "6052ab2997fa5eca871bf425987afecbd35c20bcb3d70c2337941320982fd5af"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3d782d9cf1c995e0466e62f418b8cf75cf35f13e4f4dbb4f31c640f70a91bd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2e416fa740a122c38c4b63291b77918c58ad78bde6b7e88a03b7ade5e6b461f"
    sha256 cellar: :any_skip_relocation, monterey:       "db1430a62a962e82b4b2191d108827cae2d8f091cb8425a935b94483d18327ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bdd793cec87555ca56c5607c6b5ffad77f514db8f7a14e4957620f1fbc456ef"
    sha256 cellar: :any_skip_relocation, catalina:       "be34ce891c2c7307d786a001233a398031b65a22ee2bef2fa2410ef3358fe78d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a235dd140353e721a3c798a00f7f64ff79552e8af922e73566812609118374ca"
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
