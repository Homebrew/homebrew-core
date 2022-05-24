class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.5.3.tar.gz"
  sha256 "9a5f9dc2b3b5f0876ad1e4609e1d1812e2b9ff03ea04e00c69ca05e7d9584601"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f96925359da067d210291ec02c0af0e82ec98384c423b9102acde36d14d387f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0f63fdb2fff4aa3e7aea9675df6d1d918dfc5d0f91ac21aeb401464a19318f3"
    sha256 cellar: :any_skip_relocation, monterey:       "768f0325a26f4667fbb0c5752bd1529a1fb0458147d4e3022255d5936956f699"
    sha256 cellar: :any_skip_relocation, big_sur:        "2332b2663393e5d28ccede6f4109049c899f46a14361f08d2d2ac62bc5919bec"
    sha256 cellar: :any_skip_relocation, catalina:       "7ff704ee6a93e263c04be9648d9ee5271a08c626cea12f4bdde87e70e6541de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c984844960730ba122e3cbe2ab856ac29135a436366f5ed4fc85373ad642e7ae"
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
