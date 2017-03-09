class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"

  stable do
    url "https://ftpmirror.gnu.org/guile/guile-2.0.14.tar.xz"
    mirror "https://ftp.gnu.org/gnu/guile/guile-2.0.14.tar.xz"
    sha256 "e8442566256e1be14e51fc18839cd799b966bc5b16c6a1d7a7c35155a8619d82"

    if MacOS.version >= :sierra
      # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=23870
      # https://git.net/ml/bug-guile-gnu/2016-06/msg00180.html
      # https://github.com/Homebrew/homebrew-core/issues/1957#issuecomment-229347476
      # https://gist.githubusercontent.com/rahulg/baa500e84136f0965e9ade2fb36b90ba/raw/4f1081838972ac9621fc68bb571daaf99fc0c045/libguile-stime-sierra.patch
      patch :p0 do
        url "https://raw.githubusercontent.com/macports/macports-ports/5a3bba7/lang/guile/files/sierra.patch"
        sha256 "6947f15e1aa6129f12eb692253bcc1ff969862f804de1f4d6360ad4786ae53f0"
      end

      # Filter incompat. mkostemp(3) flags on macOS 10.12
      # https://trac.macports.org/ticket/52613
      # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=24862
      patch :p0 do
        url "https://raw.githubusercontent.com/macports/macports-ports/8b7f401/lang/guile/files/sierra-filter-incompatible-mkostemp-flags.patch"
        sha256 "90750429d92a2ea97c828435645a2fd3b399e1b571ced41ff1988894155b4934"
      end
    end
  end

  bottle do
    sha256 "1de107828ea1d6eb5448b56c9ddca985fdb36b89d0de77390d4a70a04581c964" => :sierra
    sha256 "d8fc01107161424ecf8c22bb2e1bc074b5805d70c2a0525c604996112c945fa7" => :el_capitan
    sha256 "e994c1c0ca0bf0f84d91838f2bf992eda7ada179b7eef6bbd4583fd74ce79fc9" => :yosemite
  end

  devel do
    url "https://git.savannah.gnu.org/git/guile.git",
        :tag => "v2.1.7",
        :revision => "c58c143f31fe4c1717fc8846a8681de2bb4b3869"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build

    # Avoid undeclared identifier errors for SOCK_CLOEXEC and SOCK_NONBLOCK
    # Reported 19 Feb 2017 https://debbugs.gnu.org/cgi/bugreport.cgi?bug=25790
    patch :DATA
  end

  head do
    url "https://git.savannah.gnu.org/git/guile.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :run # guile-config is a wrapper around pkg-config.
  depends_on "libtool" => :run
  depends_on "libffi"
  depends_on "libunistring"
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "readline"

  fails_with :clang do
    build 211
    cause "Segfaults during compilation"
  end

  def install
    unless build.stable?
      # Avoid "address argument to atomic operation must be a pointer to _Atomic type"
      # Reported 19 Feb 2017 https://debbugs.gnu.org/cgi/bugreport.cgi?bug=25791
      ENV["ac_cv_header_stdatomic_h"] = "no"

      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "install"

    # A really messed up workaround required on macOS --mkhl
    Pathname.glob("#{lib}/*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end

    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.scm"]
  end

  test do
    hello = testpath/"hello.scm"
    hello.write <<-EOS.undent
    (display "Hello World")
    (newline)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"

    system bin/"guile", hello
  end
end

__END__
diff --git a/libguile/socket.c b/libguile/socket.c
index 64df64f..446243c 100644
--- a/libguile/socket.c
+++ b/libguile/socket.c
@@ -1655,8 +1655,12 @@ scm_init_socket ()
 
   /* accept4 flags.  No ifdef as accept4 has a gnulib
      implementation.  */
+#ifdef SOCK_CLOEXEC
   scm_c_define ("SOCK_CLOEXEC", scm_from_int (SOCK_CLOEXEC));
+#endif
+#ifdef SOCK_NONBLOCK
   scm_c_define ("SOCK_NONBLOCK", scm_from_int (SOCK_NONBLOCK));
+#endif
 
   /* setsockopt level.
