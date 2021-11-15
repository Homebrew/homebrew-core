class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.3.1.tar.gz"
  sha256 "95ecd4176dd86126d56f23d8dccbc37550b0ee1c7f22004ee5bc5a4f3547856c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e88739a7ba43c6835c87f0e3feb63c294f04abad9e0e5e889f7709de23b7a9cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45dc821c5dff3ecd759722fb547ba53aa458282b0a7cd4f7ae9896fd276f5ad0"
    sha256 cellar: :any_skip_relocation, monterey:       "d00b5d7874032d4aa20ada379091d52d4b3b5d626f1e61728167b9b0679fadfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f317e5d8221d3f7edba6036365869ae4967d6173780037c04155bcc5586b7e9"
    sha256 cellar: :any_skip_relocation, catalina:       "6e1e5388a8986a5869fec5c019103ffd205e349c1ec69b0f8af3c2bd63331edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b199e49c996e5a687f89d75eddc26675ddbfcfb326198a541167feb8faa81ef"
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
