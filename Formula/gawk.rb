class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.0.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.0.1.tar.xz"
  sha256 "8e4e86f04ed789648b66f757329743a0d6dfb5294c3b91b756a474f1ce05a794"

  bottle do
    rebuild 1
    sha256 "3bb22749e869048a14e444e738813ba883a719b757d641cf09dbc58ae3dde667" => :catalina
    sha256 "071ed9be337b30165c619cd6c5ef4204f047b81caaa860288a07d090c1a10d75" => :mojave
    sha256 "de2f0c453a79a87a9274b6ee71fa47c250783dad46573b168b5cbf71eb777d4f" => :high_sierra
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-libsigsegv-prefix",
                          "gl_cv_func_ftello_works=yes" # Work around a gnulib issue with macOS Catalina

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
