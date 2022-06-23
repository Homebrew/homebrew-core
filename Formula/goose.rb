class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.6.1.tar.gz"
  sha256 "e1caf2b7130e4d6c7190582707304c417f47c84efc2e6f79968811b30c86bc6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36a5be33869d914a6c84bf4b910b361d1416bc5220ed56e434969d9810c2015a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52a48ad2e70bed0fa3fa9c30b3bfe3a0e1c3b82f02dde2bb2f1a9d8893bc07cb"
    sha256 cellar: :any_skip_relocation, monterey:       "aefae3c533d0f154c2ce75c0e9d84495421ea523e4921e3975ff277537a21f45"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6a2404c60288250cdaf94a881351b6207d7b1812b3268b7c8e0f9c3b2944c29"
    sha256 cellar: :any_skip_relocation, catalina:       "871ece81f2fc571e7f1fcb516d2c85c9449c332f911e8ecca0e993bc2686193c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a83cdbca0886af642bebac394e8ded23096e64ff1fc60269cd5b3e1c56ed4ba"
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
