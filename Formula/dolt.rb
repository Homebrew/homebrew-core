class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.39.3.tar.gz"
  sha256 "952d9207e0f07366c20afc01b042ef321e7a457cb7be5b083b7cf49ecbe3f880"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a76c06f3fd1fc4a3316b182a6d0c723c44e9833a0db69cc3d9fc1b5f8748fa76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d95709fd620b3dd666326c73a14038059397bca0a89a75a67ae58d97eb95f86"
    sha256 cellar: :any_skip_relocation, monterey:       "b814c7d9b71c3deb8914adf76322162fba28b939af25fdbe7b06c34c522cd3ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "c30de35407dd06e3e2bff48f2d9be6ded791c30b41076e20abc708c364e4917c"
    sha256 cellar: :any_skip_relocation, catalina:       "9ad09c8125c2cbaee80c7613bbe36f23897dcf9fb4b5e0ad1b81da5aa5f1a5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d184205b9beb5022c83024a816f778b43683991c94704784ecb416a13941a5"
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
