require "language/haskell"

class Ghc < Formula
  include Language::Haskell::Cabal

  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/ghc/8.8.1/ghc-8.8.1-src.tar.xz"
  sha256 "908a83d9b814da74585de9d39687189e6260ec3848131f9d9236cab8a123721a"

  bottle do
    sha256 "ab7cfe45159057538fcde888c14ccf19b0154ac6e0e2d9bd92727c5a0b7734d5" => :mojave
    sha256 "6736c0d1bbff9d7c775c70979b4df8e54d2183ded84965bc44fa6b0c16a0996c" => :high_sierra
    sha256 "4cb157956afc659f762e22e54c189e609d93a7f04f0d1ae6919eaafa5b255f74" => :sierra
  end

  head do
    url "https://gitlab.haskell.org/ghc/ghc.git", :branch => "ghc-8.8"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "cabal" do
      url "https://hackage.haskell.org/package/cabal-install-3.0.0.0/cabal-install-3.0.0.0.tar.gz"
      sha256 "a432a7853afe96c0fd80f434bd80274601331d8c46b628cd19a0d8e96212aaf1"
    end
  end

  depends_on "python" => :build
  depends_on "sphinx-doc" => :build

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
    mirror "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
    mirror "https://ftpmirror.gnu.org/gmp/gmp-6.1.2.tar.xz"
    sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"
  end

  # https://www.haskell.org/ghc/download_ghc_8_6_5.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # Need to use 8.6.5 to build 8.8.1 because of
  # https://gitlab.haskell.org/ghc/ghc/issues/17146
  resource "binary" do
    url "https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-apple-darwin.tar.xz"
    sha256 "dfc1bdb1d303a87a8552aa17f5b080e61351f2823c2b99071ec23d0837422169"
  end

  # workaround for https://gitlab.haskell.org/ghc/ghc/issues/17114
  patch :DATA

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"

    # Build a static gmp rather than in-tree gmp, otherwise all ghc-compiled
    # executables link to Homebrew's GMP.
    gmp = libexec/"integer-gmp"

    # GMP *does not* use PIC by default without shared libs so --with-pic
    # is mandatory or else you'll get "illegal text relocs" errors.
    resource("gmp").stage do
      system "./configure", "--prefix=#{gmp}", "--with-pic", "--disable-shared",
                            "--build=#{Hardware.oldest_cpu}-apple-darwin#{`uname -r`.to_i}"
      system "make"
      system "make", "check"
      system "make", "install"
    end

    args = ["--with-gmp-includes=#{gmp}/include",
            "--with-gmp-libraries=#{gmp}/lib"]

    # As of Xcode 7.3 (and the corresponding CLT) `nm` is a symlink to `llvm-nm`
    # and the old `nm` is renamed `nm-classic`. Building with the new `nm`, a
    # segfault occurs with the following error:
    #   make[1]: * [compiler/stage2/dll-split.stamp] Segmentation fault: 11
    # Upstream is aware of the issue and is recommending the use of nm-classic
    # until Apple restores POSIX compliance:
    # https://ghc.haskell.org/trac/ghc/ticket/11744
    # https://ghc.haskell.org/trac/ghc/ticket/11823
    # https://mail.haskell.org/pipermail/ghc-devs/2016-April/011862.html
    # LLVM itself has already fixed the bug: llvm-mirror/llvm@ae7cf585
    # rdar://25311883 and rdar://25299678
    if DevelopmentTools.clang_build_version >= 703 && DevelopmentTools.clang_build_version < 800
      args << "--with-nm=#{`xcrun --find nm-classic`.chomp}"
    end

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    if build.head?
      resource("cabal").stage do
        system "sh", "bootstrap.sh", "--sandbox"
        (buildpath/"bootstrap-tools/bin").install ".cabal-sandbox/bin/cabal"
      end

      ENV.prepend_path "PATH", buildpath/"bootstrap-tools/bin"

      cabal_sandbox do
        cabal_install "--only-dependencies", "happy", "alex"
        cabal_install "--prefix=#{buildpath}/bootstrap-tools", "happy", "alex"
      end

      system "./boot"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    system "#{bin}/runghc", testpath/"hello.hs"
  end
end
__END__
diff --git a/configure b/configure
index e00a480..6db08ee 100755
--- a/configure
+++ b/configure
@@ -11525,6 +11525,8 @@ fi;
 fi
 { $as_echo "$as_me:${as_lineno-$LINENO}: result: $fptools_cv_alex_version" >&5
 $as_echo "$fptools_cv_alex_version" >&6; }
+if test ! -f compiler/cmm/CmmLex.hs || test ! -f compiler/parser/Lexer.hs
+then
 fp_version1=$fptools_cv_alex_version; fp_version2=3.1.7
 fp_save_IFS=$IFS; IFS='.'
 while test x"$fp_version1" != x || test x"$fp_version2" != x
@@ -11548,6 +11550,7 @@ IFS=$fp_save_IFS
 if test "$fp_num1" -lt "$fp_num2"; then :
   as_fn_error $? "Alex version 3.1.7 or later is required to compile GHC." "$LINENO" 5
 fi
+fi
 AlexVersion=$fptools_cv_alex_version;
 
 
