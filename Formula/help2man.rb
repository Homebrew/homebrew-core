class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.15.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.15.tar.xz"
  sha256 "c25a35b30eceb315361484b0ff1f81c924e8ee5c8881576f1ee762f001dbcd1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "236779ca51f0503bc80da88ef43433976361d779ac851a5f65220b6ca84e7f44" => :catalina
    sha256 "236779ca51f0503bc80da88ef43433976361d779ac851a5f65220b6ca84e7f44" => :mojave
    sha256 "236779ca51f0503bc80da88ef43433976361d779ac851a5f65220b6ca84e7f44" => :high_sierra
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
