class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.0.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.0.0.tar.xz"
  sha256 "50f091ed0eb485ad87dbb620d773a3e2c31a27f75f5e008f7bf065055f024406"

  bottle do
    sha256 "0eb61cf2dc448b97f4f27054db3a3580482aae8c77a9fa5008844361f4c591c8" => :mojave
    sha256 "8b935dbbfcc134e9f546399fc16ec87c446a30a3de59621e1b40dcefa78a97f8" => :high_sierra
    sha256 "e4cf8406600238bcf9c0cfecc98a7d82f96720ea7f13855fa5dd4efc43936356" => :sierra
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
