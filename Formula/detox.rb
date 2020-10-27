class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.io/"
  url "https://github.com/dharple/detox/archive/v1.3.0.tar.gz"
  sha256 "00daf6b019b51c7bbc3ac96deeeec18fd886c144eeee97c3372dd297bb134c84"
  license "BSD-3-Clause"

  bottle do
    sha256 "34cf8b1f4375e659bb76d81fbe298ae6afed01ecd6cd070755b3eabc409c329a" => :catalina
    sha256 "d8b6b72801850f3cf9ecc81e5dfbdcbc77de66c4dc65b49efd008dcb8aadc432" => :mojave
    sha256 "07b8fe6a481bac0864ccc50939980aad50772c4af9c15d57f95d81ad41acda8e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--mandir=#{man}", "--prefix=#{prefix}"
    system "make"
    (prefix/"etc").mkpath
    pkgshare.mkpath
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
