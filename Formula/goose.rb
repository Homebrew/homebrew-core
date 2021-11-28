class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.4.1.tar.gz"
  sha256 "13cac5b591ab4d4946c739e73b74aa6dfb17a05ad51fc63ae34615a0edf31600"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c48fc8b54b098ce182190d77b2016971cac4a11bf296e3e226e21343f7cb3b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e76fdc96dd47d19b39113ee696235be5ec513ae05cd0b2310f7e3d2edc8fa35b"
    sha256 cellar: :any_skip_relocation, monterey:       "adfdeafe5b3cd096b89108fbb33453f543e800fabf5869b7542c9a46f81446e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6355e7b08e54bc034f150d24ba9e553abf620566a76b01b7db13c5e3f021af80"
    sha256 cellar: :any_skip_relocation, catalina:       "0b8beef84abcd5f10954d99ce74c89735e1d3304a7cc72779ea5e584b97f66ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5befba5803fa95ce15bfb9b36b41042d65e38e006256a6f5e0843fcdd8a44609"
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
