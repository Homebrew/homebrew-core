class AutomakeAT112 < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftpmirror.gnu.org/automake/automake-1.12.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/automake/automake-1.12.6.tar.gz"
  sha256 "0cbe570db487908e70af7119da85ba04f7e28656b26f717df0265ae08defd9ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec1f95863cad359c6278cf4986e417dc189fcb827c8051729091df80875ae17c" => :sierra
    sha256 "fd6dc4d4af7cfb4b89e1bc966e03b53f04f44e70b5675aeef591df5c2c0ccf31" => :el_capitan
    sha256 "fd6dc4d4af7cfb4b89e1bc966e03b53f04f44e70b5675aeef591df5c2c0ccf31" => :yosemite
  end

  keg_only :provided_until_xcode43

  depends_on "autoconf" => :run

  def install
    system "./configure", "--prefix=#{prefix}", "--program-suffix=112"
    system "make", "install"

    # Fix aclocal not escaping @ character correctly.
    inreplace "#{bin}/aclocal112",
      "\"#{share}/aclocal-$APIVERSION\"",
      "\"#{HOMEBREW_CELLAR}/automake\\@1.12/#{pkg_version}/share/aclocal-$APIVERSION\""

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<-EOS.undent
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int main() { return 0; }
    EOS
    (testpath/"configure.ac").write <<-EOS.undent
      AC_INIT(test, 1.0)
      AM_INIT_AUTOMAKE
      AC_PROG_CC
      AC_CONFIG_FILES(Makefile)
      AC_OUTPUT
    EOS
    (testpath/"Makefile.am").write <<-EOS.undent
      bin_PROGRAMS = test
      test_SOURCES = test.c
    EOS
    system bin/"aclocal112"
    system bin/"automake112", "--add-missing", "--foreign"
    system "autoconf"
    system "./configure"
    system "make"
    system "./test"
  end
end
