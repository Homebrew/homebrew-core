class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.5.2.tar.gz"
  sha256 "03497092914408fe5f2fd54555505bb46227dc0aea193a95a530404542963913"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d490170f8ab218f0099e30066963103120218b8ae9e7aa213831087b0132f800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cadbb8a7aae376bcf73647e599a3ef39ab0cb80ff2a7e5d6ef4fca401eee6a0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b435da3cbae391f6ef1bea845f0f4fcf78c33e42419c4f6e5fa8599defe90b1"
    sha256 cellar: :any_skip_relocation, ventura:        "ef795d6ca46b35a26757b0080ea60723c71dc44b44ec177da5dd5337a4cefbdb"
    sha256 cellar: :any_skip_relocation, monterey:       "833d8360a75f3b0782f7b22a6c74be05dd4ebfdae19d2740c0f770b7798ee715"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc80ab738340c186b7afe88d42658de1ab0279b9bc17a5889a1b057d2dc85f64"
    sha256 cellar: :any_skip_relocation, catalina:       "515c0f12c3dec162ac5047a21d951fd0fa93c11685afed6316101b198a2544b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25f2517dd1ebf95dcd1b83f2c18b35e66f210dc9488227591bca37dc6cfcee48"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
