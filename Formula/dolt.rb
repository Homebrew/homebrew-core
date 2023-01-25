class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.11.tar.gz"
  sha256 "6e64ee5b31b53015b34ccdc534018f10733745c9d7b7b37ae3ff0291ea6e85f3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "350188b4980c093402514c51bd18c07001624c82856a8dc1bcce26f44fb2489f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4938b2299b610d15d431e07b1408eae816f3322c7d94f1acfb2b86f96429c6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec0049f955c80f41896c275eae7b9eed771458af1b19f7642da3816531f7319e"
    sha256 cellar: :any_skip_relocation, ventura:        "f675761d7aa81c9c9fdd7818867d48098f870a7014b54443bf52681f543c9a19"
    sha256 cellar: :any_skip_relocation, monterey:       "6cc131e2a6ed32fbf3d39791ccd5bf03ff651d35a93e6c35ff9e2ac2d8ddf680"
    sha256 cellar: :any_skip_relocation, big_sur:        "8de2973da352313bcb5c3781c057835deae8932e4b8f5b37bd42bba6d6be482d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd9baf0698ad0c70a447d00d6712fcb49983ac3ba058071ad2fb2afc1eb0e3c"
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
