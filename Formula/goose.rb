class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.0.0.tar.gz"
  sha256 "8bcc01575d6eb2d7e63c1b362d257835c41f74b328a36224fa057857398d73b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7a4098e939b398cd06ccac9823e1a8cf4b5ba4a48d02c7107db2c290254f4e78"
    sha256 cellar: :any_skip_relocation, big_sur:       "1407a16971b246018e4972126f720f1e18b98423cd25a47264b1b82c5656ec06"
    sha256 cellar: :any_skip_relocation, catalina:      "46e6b4b88d7040d25915ebf03a11aab7a5e5963d985b2773231cbc208617c633"
    sha256 cellar: :any_skip_relocation, mojave:        "2aabf2ca4b1e124a6f2837379bbfbcbda6e75265535769921b22aa36eff68f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97bd752caa86d45671e9654dc041d05c6007c9292269438ecf5bd7d4e56a50d7"
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
