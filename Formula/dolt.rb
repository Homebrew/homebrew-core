class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.4.tar.gz"
  sha256 "29e748422207a1b67abe2b04f1d81d2a123c750c662d7de01007b0f6c13c9f5f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44b30171c748f26584f3bef1ef0e16f37908d5d193da480c0bdf8ecf28fe07fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab1d68ba6f445f7a27a2c2c238668c7fe89e4442981a5fe38f52a7eb19191aac"
    sha256 cellar: :any_skip_relocation, monterey:       "8750e776ace86df5667e0c9bd3d3f80b0e61053c105a9ff5c6a9b20db3f268fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "de1a4554292e5afae413b3b4fc70eb8303c1b89e2a5cae288242b5caa17dac0e"
    sha256 cellar: :any_skip_relocation, catalina:       "c4aed56a7ccd1654e75da6440056cb27e6e3e3fdd55704905c761c6fa62b6755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe2699039dd27e9d3d92e0459d12633788c3a8e2856e0ca22710f5c26d82caa7"
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
