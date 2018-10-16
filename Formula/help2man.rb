class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.8.tar.xz"
  sha256 "528f6a81ad34cbc76aa7dce5a82f8b3d2078ef065271ab81fda033842018a8dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a36ae93e8f2427d29c90f966c201db1510777a3337802ebefbf2c2f76449647" => :mojave
    sha256 "a89c64579fee5d04b2b94a77489a36ddf8bf4a92d03d705b4ca091446ed2bb1e" => :high_sierra
    sha256 "a89c64579fee5d04b2b94a77489a36ddf8bf4a92d03d705b4ca091446ed2bb1e" => :sierra
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
