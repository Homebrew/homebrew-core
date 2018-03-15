class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-4.2.1.tar.xz"
  sha256 "d1119785e746d46a8209d28b2de404a57f983aa48670f4e225531d3bdc175551"

  bottle do
    sha256 "617115fcba047189d0a86aad82382768fec90a49c9d86f2fb944aec440ea64b2" => :high_sierra
    sha256 "f60a61f057eefb9114f8080460fdb31d71b1f3fd6dd6daf855f380dfb4ae4fa1" => :sierra
    sha256 "aacfd8339f28ace56c4145cddd18986b050a14f408cdceb90d05eeb1bcf08590" => :el_capitan
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
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
