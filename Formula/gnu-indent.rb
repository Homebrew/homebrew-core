class GnuIndent < Formula
  desc "C code prettifier"
  homepage "https://www.gnu.org/software/indent/"
  url "https://ftp.gnu.org/gnu/indent/indent-2.2.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/indent/indent-2.2.12.tar.gz"
  sha256 "e77d68c0211515459b8812118d606812e300097cfac0b4e9fb3472664263bb8b"
  revision 1

  bottle do
    sha256 "82a12279be8834591a2104253ac562978b557c26b262dd8d5bfbf6e7b1103dd1" => :catalina
    sha256 "e960e3f35f6a77daef487f54158953522f58a27caf27e39e0c17702754718ee1" => :mojave
    sha256 "3280e6e9fc0c5cc895367291fc328dccae5f2e36606dd503b5721d449bc33eb8" => :high_sierra
    sha256 "98bcdee2e49d7e165a07ce6468d2c1a3030db7205472d015ba516e43f5a1e0fd" => :sierra
  end

  depends_on "gettext"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --program-prefix=g
    ]

    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gindent" => "indent"
    (libexec/"gnuman/man1").install_symlink man1/"gindent.1" => "indent.1"

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    <<~EOS
      GNU "indent" has been installed as "gindent".
      If you need to use it as "indent", you can add a "gnubin" directory
      to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    (testpath/"test.c").write("int main(){ return 0; }")
    system "#{bin}/gindent", "test.c"
    assert_equal File.read("test.c"), <<~EOS
      int
      main ()
      {
        return 0;
      }
    EOS
  end
end
