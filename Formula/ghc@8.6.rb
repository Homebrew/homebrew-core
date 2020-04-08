require "language/haskell"

class GhcAT86 < Formula
  include Language::Haskell::Cabal

  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-src.tar.xz"
  sha256 "4d4aa1e96f4001b934ac6193ab09af5d6172f41f5a5d39d8e43393b9aafee361"
  revision 1

  bottle do
    sha256 "1167f06250256e73d147e8fc0d83e08915f38997792f7afb03a6a292be76b20b" => :catalina
    sha256 "93501010b8272059bbcf1d3c0c5ca32150466e8756773198d39c3810e9103889" => :mojave
    sha256 "1a9d50a816fc2c795f4fe2b55540b7c9b04ba3d9b72cf345f7294a044e2b8250" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "python@3.8" => :build
  depends_on "sphinx-doc" => :build

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
    mirror "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
    mirror "https://ftpmirror.gnu.org/gmp/gmp-6.1.2.tar.xz"
    sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"
  end

  # https://www.haskell.org/ghc/download_ghc_8_6_5#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  resource "binary" do
    url "https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-apple-darwin.tar.xz"
    sha256 "dfc1bdb1d303a87a8552aa17f5b080e61351f2823c2b99071ec23d0837422169"
  end

  # Fix for Catalina compatibility https://gitlab.haskell.org/ghc/ghc/issues/17353
  patch :DATA

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"

    # Build a static gmp rather than in-tree gmp, otherwise all ghc-compiled
    # executables link to Homebrew's GMP.
    gmp = libexec/"integer-gmp"

    # GMP *does not* use PIC by default without shared libs so --with-pic
    # is mandatory or else you'll get "illegal text relocs" errors.
    resource("gmp").stage do
      system "./configure", "--prefix=#{gmp}", "--with-pic", "--disable-shared",
                            "--build=#{Hardware.oldest_cpu}-apple-darwin#{`uname -r`.to_i}"
      system "make"
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
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
__END__
diff -pur a/rts/Linker.c b/rts/Linker.c
--- a/rts/Linker.c	2019-08-25 21:03:36.000000000 +0900
+++ b/rts/Linker.c	2019-11-05 11:09:06.000000000 +0900
@@ -192,7 +192,7 @@ int ocTryLoad( ObjectCode* oc );
  *
  * MAP_32BIT not available on OpenBSD/amd64
  */
-#if defined(x86_64_HOST_ARCH) && defined(MAP_32BIT)
+#if defined(x86_64_HOST_ARCH) && defined(MAP_32BIT) && !defined(__APPLE__)
 #define TRY_MAP_32BIT MAP_32BIT
 #else
 #define TRY_MAP_32BIT 0
@@ -214,7 +214,7 @@ int ocTryLoad( ObjectCode* oc );
  */
 #if !defined(ALWAYS_PIC) && defined(x86_64_HOST_ARCH)

-#if defined(MAP_32BIT)
+#if defined(MAP_32BIT) && !defined(__APPLE__)
 // Try to use MAP_32BIT
 #define MMAP_32BIT_BASE_DEFAULT 0
 #else
