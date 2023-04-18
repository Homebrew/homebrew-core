class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/v3.10.0.tar.gz"
  sha256 "df6ac59600609ad1d18846f3b29e6b83764d396c247b4d0a0cadfa3f48a2e27c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9135daff0a43b932861d5bb3e1789eeb2438803ecf3f83b5c5dc725733a9e024"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92ee69e093cc61158687de8894276ce899516c8599ee60415df7e05df9c878fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d747c7e2f64ca820be051abf2a50a7f2769b82849272dbc704baeaa00f9d55d8"
    sha256 cellar: :any_skip_relocation, ventura:        "355fae4658f8113c280d9616d550af7600529159fa20e41bef8396b45d22796b"
    sha256 cellar: :any_skip_relocation, monterey:       "6e11002dadcb91a731d7e512ca39fdcd0aa4f4a5e70c31fe6211b379676ea56b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a074a76ade74ded15fa0ea580751a895a68dea57ddd1bfcb4babecefc4a84bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da824fadc7285f0d3523c94e93eeaf15308d9edd1a43ba20d74a4a8f5a99aa13"
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
