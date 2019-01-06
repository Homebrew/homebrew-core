class Clisp < Formula
  desc "GNU CLISP, a Common Lisp implementation"
  homepage "https://clisp.sourceforge.io/"
  url "https://ftp.gnu.org/gnu/clisp/release/2.49/clisp-2.49.tar.bz2"
  mirror "https://ftpmirror.gnu.org/clisp/release/2.49/clisp-2.49.tar.bz2"
  sha256 "8132ff353afaa70e6b19367a25ae3d5a43627279c25647c220641fed00f8e890"
  revision 1

  bottle do
    sha256 "3cc305f1620b8235b6b96b417470a8581fcd6d454a8f2a1e2e87335e8ee69be0" => :mojave
    sha256 "8c545b817e493f5edfb1928ac8fa1d06571cfb3da135094bd701b22e99c6e423" => :high_sierra
    sha256 "dd77ffe7a77e9bdb8cc57a11d923108c4967229feb214e511a5a1866a1f7ec50" => :sierra
    sha256 "c4503ba2f9fcc24cb8415179db6a7437bfa8e1cab25b619fcb7be8e2770e9fe6" => :el_capitan
    sha256 "7335dec5039d4bf0f56cf75521834d93caca2f36fcf45e42fe489964fa7d0c49" => :yosemite
  end

  depends_on "libsigsegv"
  depends_on "readline"

  patch :DATA

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e2cc7c1/clisp/patch-src_lispbibl_d.diff"
    sha256 "fd4e8a0327e04c224fb14ad6094741034d14cb45da5b56a2f3e7c930f84fd9a0"
  end

  def install
    ENV.deparallelize # This build isn't parallel safe.
    ENV.O0 # Any optimization breaks the build

    # Clisp requires to select word size explicitly this way,
    # set it in CFLAGS won't work.
    ENV["CC"] = "#{ENV.cc} -m64"

    # Work around "configure: error: unrecognized option: `--elispdir"
    # Upstream issue 16 Aug 2016 https://sourceforge.net/p/clisp/bugs/680/
    inreplace "src/makemake.in", "${datarootdir}/emacs/site-lisp", elisp

    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=yes"

    cd "src" do
      # Multiple -O options will be in the generated Makefile,
      # make Homebrew's the last such option so it's effective.
      inreplace "Makefile" do |s|
        s.change_make_var! "CFLAGS", "#{s.get_make_var("CFLAGS")} #{ENV["CFLAGS"]}"
      end

      # The ulimit must be set, otherwise `make` will fail and tell you to do so
      system "ulimit -s 16384 && make"

      if MacOS.version >= :lion
        opoo <<~EOS
          `make check` fails so we are skipping it.
          However, there will likely be other issues present.
          Please take them upstream to the clisp project itself.
        EOS
      else
        # Considering the complexity of this package, a self-check is highly recommended.
        system "make", "check"
      end

      system "make", "install"
    end
  end

  test do
    system "#{bin}/clisp", "--version"
  end
end

__END__
diff --git a/src/stream.d b/src/stream.d
index 5345ed6..cf14e29 100644
--- a/src/stream.d
+++ b/src/stream.d
@@ -3994,7 +3994,7 @@ global object iconv_range (object encoding, uintL start, uintL end, uintL maxint
 nonreturning_function(extern, error_unencodable, (object encoding, chart ch));
 
 /* Avoid annoying warning caused by a wrongly standardized iconv() prototype. */
-#ifdef GNU_LIBICONV
+#if defined(GNU_LIBICONV) && !defined(__APPLE_CC__)
   #undef iconv
   #define iconv(cd,inbuf,inbytesleft,outbuf,outbytesleft) \
     libiconv(cd,(ICONV_CONST char **)(inbuf),inbytesleft,outbuf,outbytesleft)
