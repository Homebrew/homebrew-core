class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.0.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.0.0.tar.xz"
  sha256 "50f091ed0eb485ad87dbb620d773a3e2c31a27f75f5e008f7bf065055f024406"
  revision 1

  bottle do
    sha256 "47559c1ecaa9ee95cac1f7ae5c2a56c16e206c4f1b0bf1b25d6c0ee5ad8f5ac3" => :mojave
    sha256 "1871a29927d77bc704a088ab5750af3ad56c08ae4762c8faafca1a39b0be0bac" => :high_sierra
    sha256 "d0ea7024988dc4c6d43e3bf65b48640fcb67160bddbfd3bb08888be642bfeeff" => :sierra
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-libsigsegv-prefix"
    system "make"
    system "make", "check"
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gawk" => "awk"
    (libexec/"gnuman/man1").install_symlink man1/"gawk.1" => "awk.1"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
