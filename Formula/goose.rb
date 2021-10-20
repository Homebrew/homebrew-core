class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.2.0.tar.gz"
  sha256 "ce77bbea92565d3aeeec4a751dd4755c730a60f968eb1926850f041bf602e1e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c1cab5758f96a33f14423bb465613a53339c54f1f3c6adf86568c06084b4245e"
    sha256 cellar: :any_skip_relocation, big_sur:       "dc23abcdbea2aef77700ab3662add810975f49d052500d1b6d04364546811b11"
    sha256 cellar: :any_skip_relocation, catalina:      "1671caff48bfb3e34f346d2441fe4327211394bd9fc3f51e26d97b4666a91aa8"
    sha256 cellar: :any_skip_relocation, mojave:        "de5429253c76841e33941d9197355447b9755c5a06bd158356af9e31208b3372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92a783c135d866ab72462ebaf7ea00bd2571a9c5272d3e1e75d8b84758327fba"
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
