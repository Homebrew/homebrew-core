class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/v3.10.0.tar.gz"
  sha256 "df6ac59600609ad1d18846f3b29e6b83764d396c247b4d0a0cadfa3f48a2e27c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fd235460429b5899cdf8ea5341eee4aad7e8bd6341b7939619ba13839e96ecb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19d5ff4709f1cf956a1a67167daae1343cdafe4b5b17c57d52810df42e5d3745"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69f227d890a9137360c96293a9d54c8c98599cc7f8084cdceba5af802e27a44a"
    sha256 cellar: :any_skip_relocation, ventura:        "a24ca911c02580cdcb88172ec29e23840be7415265c2134e671580a508252680"
    sha256 cellar: :any_skip_relocation, monterey:       "a0d4bd96f4000db1f27f98a9f2aadfbe55c5ce0f70554b34e6e8ea14b3c10f28"
    sha256 cellar: :any_skip_relocation, big_sur:        "9140c30159af04615db62d7c45e6974f9a9163f186bfdd9f5df35839e7e40d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56f1724a08d39e13e3f9f1419874129c593d041ccc791b1997283d9843aba1bc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
