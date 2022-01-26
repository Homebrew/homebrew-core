class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.5.1.tar.gz"
  sha256 "31dafd95b1f568ac35e686b85b36cdcaba5106098c4d57b5bdad7a584d15aaee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dda1576e717341e3962002901164c94dab4a34c51416696fb268de838735bcc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9952f6a72f01ace913ad6782d598bfa72ca721e5ff751a88841681131141f92b"
    sha256 cellar: :any_skip_relocation, monterey:       "49638e9e10f889bdadc07f7a68f022c78e671589a44775df929f67b430182e92"
    sha256 cellar: :any_skip_relocation, big_sur:        "0befd9144c84fa729006829bd62826036fdbe903af42ca78b9bb0ea1f3f8724d"
    sha256 cellar: :any_skip_relocation, catalina:       "46cd1e2b2e4af854f9379b9275703641b7be6f8a4ac05be6d876d12291e983fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "272d77d3f8445cf9a255a2b4308435833c1915b744927443ae430d0459340e0a"
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
