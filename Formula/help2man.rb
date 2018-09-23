class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.7.tar.xz"
  sha256 "585b8e88ed04bdb426403cf7d9b0c0bb9c7630755b0096c2b018a024b29bec0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "af4cc82004bdfd9ea1b8d67177e0a3a3ed6f56264741c7703865443c459d9915" => :mojave
    sha256 "8c2d747894baec4af17523abb21390651d931b2743dd90f043e434ae35d6f55c" => :high_sierra
    sha256 "8c2d747894baec4af17523abb21390651d931b2743dd90f043e434ae35d6f55c" => :sierra
    sha256 "8c2d747894baec4af17523abb21390651d931b2743dd90f043e434ae35d6f55c" => :el_capitan
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
