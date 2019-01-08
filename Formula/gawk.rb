class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-4.2.1.tar.xz"
  sha256 "d1119785e746d46a8209d28b2de404a57f983aa48670f4e225531d3bdc175551"
  revision 1

  bottle do
    rebuild 1
    sha256 "bf7cdce224032a58bfaadc3a87024ae7cb6490a5fef6c5f1d4631a1e41585716" => :mojave
    sha256 "3e915ae4989aaba561315c95923bd70ab2a5eaf661b6003359a50c2add2ee758" => :high_sierra
    sha256 "df69c7a625a6bf308841a603c80211ed8cb67d57e3d2d13cdc07da50c879de4f" => :sierra
    sha256 "00053f97981327326623a8adc914b5431e3f8797aaec15342a3c0ebb4bf1eb9d" => :el_capitan
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
