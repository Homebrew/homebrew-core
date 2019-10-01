class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.0.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.0.1.tar.xz"
  sha256 "8e4e86f04ed789648b66f757329743a0d6dfb5294c3b91b756a474f1ce05a794"

  bottle do
    sha256 "344c60c2d5c4fa952f2ae0c43efbef0e447b045e2ae648d11886483b3375dc36" => :mojave
    sha256 "9aaa755a220119fabb40dbb4b0edecabd976d34f0ac5d4f1277eb0f0fc8e4933" => :high_sierra
    sha256 "a69334c37cf4c58c44f2974bf092a2531798ff4ace6aa0ee884798b375dd9708" => :sierra
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
