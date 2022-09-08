class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.41.0.tar.gz"
  sha256 "ca43ecc64220278c6e384f46339ca4b0a9bbde99d569fc97a94eafb64970c0aa"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "099852e31a48bf5b58f18834337fd7a594299ead8fda49dd417d869c439136b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de1b171942cc1cd25b796e6f3189db9bcfced4e9fa31d9e3894ac5b16badc39f"
    sha256 cellar: :any_skip_relocation, monterey:       "65d91f6e7538e7463b7ce04fdec0e5627a742402254b28d92f36ae09c15a8e19"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbf3a6be252c8e909cc9a8c5c1ddbd260ddaed3afbf62bba31d338da6afee2e1"
    sha256 cellar: :any_skip_relocation, catalina:       "d0123c99813654252bd13e7d6e2646e17a8f0b4faadcf8225fddff40d455b8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c53bd52a7b97291fb805166d593d14318ef33e60ca9a67ed2a249b09cea4167"
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
