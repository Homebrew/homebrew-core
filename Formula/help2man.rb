class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.13.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.13.tar.xz"
  sha256 "b7f8bbad1f2c405db747e3f5a4d5e1eddc63b360221c824bf79748f27b560523"

  bottle do
    cellar :any_skip_relocation
    sha256 "588a65fb8b07ae7738c043122429901edd8c80b825039335a998aa0f31e167fb" => :catalina
    sha256 "588a65fb8b07ae7738c043122429901edd8c80b825039335a998aa0f31e167fb" => :mojave
    sha256 "588a65fb8b07ae7738c043122429901edd8c80b825039335a998aa0f31e167fb" => :high_sierra
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "help2man #{version}", shell_output("#{bin}/help2man #{bin}/help2man")
  end
end
