require "language/haskell"

class Ghc < Formula
  include Language::Haskell::Cabal

  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.0.2/ghc-8.0.2-src.tar.xz"
  sha256 "11625453e1d0686b3fa6739988f70ecac836cadc30b9f0c8b49ef9091d6118b1"

  bottle do
    sha256 "bb2f8381ad551dfd540a2cad0db09b11f38a67090795b6b374d4bf596361e924" => :sierra
    sha256 "84dcf85c4e902d476bc41ab3882c375d7144428534945531712905be5d5d9984" => :el_capitan
    sha256 "e3f2a2f09b463b4cb1afcc1556e725d97cf53f52447553361690342a530a2746" => :yosemite
    sha256 "a1e4184f0b5a53002a5cdf120716f4d8aa38f036eb28a157069cb69995a82ee9" => :x86_64_linux
  end

  head do
    url "https://git.haskell.org/ghc.git", :branch => "ghc-8.0"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "cabal" do
      url "https://hackage.haskell.org/package/cabal-install-1.24.0.2/cabal-install-1.24.0.2.tar.gz"
      sha256 "2ac8819238a0e57fff9c3c857e97b8705b1b5fef2e46cd2829e85d96e2a00fe0"
    end
  end

  option "with-test", "Verify the build using the testsuite"
  option "without-docs", "Do not build documentation (including man page)"
  deprecated_option "tests" => "with-test"
  deprecated_option "with-tests" => "with-test"

  depends_on :macos => :lion
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "m4" => :build unless OS.mac?
  depends_on "ncurses" unless OS.mac?

  # This dependency is needed for the bootstrap executables.
  depends_on "gmp" => :build unless OS.mac?

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
    mirror "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
    mirror "https://ftpmirror.gnu.org/gmp/gmp-6.1.2.tar.xz"
    sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"
  end

  if MacOS.version <= :lion
    fails_with :clang do
      cause <<-EOS.undent
        Fails to bootstrap ghc-cabal. Error is:
          libraries/Cabal/Cabal/Distribution/Compat/Binary/Class.hs:398:14:
              The last statement in a 'do' block must be an expression
                n <- get :: Get Int getMany n
      EOS
    end
  end

  # https://www.haskell.org/ghc/download_ghc_8_0_1#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  resource "binary" do
    if OS.linux?
      # Using 8.0.1 gives the error message:
      # strip: Not enough room for program headers, try linking with -N
      url "http://downloads.haskell.org/~ghc/7.8.4/ghc-7.8.4-x86_64-unknown-linux-deb7.tar.xz"
      sha256 "f62e00e93a5ac16ebfe97cd7cb8cde6c6f3156073d4918620542be3e0ad55f8d"
    else
      url "https://downloads.haskell.org/~ghc/8.0.2/ghc-8.0.2-x86_64-apple-darwin.tar.xz"
      sha256 "ff50a2df9f002f33b9f09717ebf5ec5a47906b9b65cc57b1f9849f8b2e06788d"
    end
  end

  resource "testsuite" do
    url "https://downloads.haskell.org/~ghc/8.0.2/ghc-8.0.2-testsuite.tar.xz"
    sha256 "52235d299eb56292f2c273dc490792788b8ba11f4dc600035d050c8a4c1f4cf2"
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV.deparallelize if ENV["CIRCLECI"]

    # Setting -march=native, which is what --build-from-source does, fails
    # on Skylake (and possibly other architectures as well) with the error
    # "Segmentation fault: 11" for at least the following files:
    #   utils/haddock/dist/build/Haddock/Backends/Hyperlinker/Types.dyn_o
    #   utils/haddock/dist/build/Documentation/Haddock/Types.dyn_o
    #   utils/haddock/dist/build/Haddock/GhcUtils.dyn_o
    #   utils/haddock/dist/build/Paths_haddock.dyn_o
    #   utils/haddock/dist/build/ResponseFile.dyn_o
    # Setting -march=core2 works around the bug.
    # Reported 22 May 2016: https://ghc.haskell.org/trac/ghc/ticket/12100
    # Note that `unless build.bottle?` avoids overriding --bottle-arch=[...].
    ENV["HOMEBREW_OPTFLAGS"] = "-march=#{Hardware.oldest_cpu}" unless build.bottle?

    # Build a static gmp rather than in-tree gmp, otherwise it links to brew's.
    gmp = libexec/"integer-gmp"

    # MPN_PATH: The lowest common denominator asm paths that work on Darwin,
    # corresponding to Yonah and Merom. Obviates --disable-assembly.
    ENV["MPN_PATH"] = "x86_64/fastsse x86_64/core2 x86_64 generic" if build.bottle?

    # GMP *does not* use PIC by default without shared libs  so --with-pic
    # is mandatory or else you'll get "illegal text relocs" errors.
    resource("gmp").stage do
      system "./configure", "--prefix=#{gmp}", "--with-pic", "--disable-shared"
      system "make"
      system "make", "check"
      ENV.deparallelize { system "make", "install" }
    end

    args = ["--with-gmp-includes=#{gmp}/include",
            "--with-gmp-libraries=#{gmp}/lib",
            "--with-ld=ld", # Avoid hardcoding superenv's ld.
            "--with-gcc=#{OS.mac? ? ENV.cc : "gcc"}"] # Always.

    if ENV.compiler == :clang
      args << "--with-clang=#{OS.mac? ? ENV.cc : "clang"}"
    end

    if OS.linux?
      # Fix error while loading shared libraries: libgmp.so.3, libgmp.so.10
      ln_s Formula["gmp"].lib/"libgmp.so", gmp/"lib/libgmp.so.3"
      ln_s Formula["gmp"].lib/"libgmp.so", gmp/"lib/libgmp.so.10"
      ENV.prepend_path "LD_LIBRARY_PATH", gmp/"lib"
      # Fix /usr/bin/ld: cannot find -lgmp
      ENV.prepend_path "LIBRARY_PATH", gmp/"lib"
      # Fix ghc-stage2: error while loading shared libraries: libncursesw.so.5
      ln_s Formula["ncurses"].lib/"libncursesw.so", gmp/"lib/libncursesw.so.5"
      # Fix ghc-pkg: error while loading shared libraries: libncursesw.so.6
      ENV.prepend_path "LD_LIBRARY_PATH", Formula["ncurses"].lib
    end

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
      # Change the dynamic linker and RPATH of the binary executables.
      if OS.linux? && Formula["glibc"].installed?
        keg = Keg.new(prefix)
        Dir["ghc/stage2/build/tmp/ghc-stage2", "libraries/*/dist-install/build/*.so",
            "rts/dist/build/*.so*", "utils/*/dist*/build/tmp/*"].each do |s|
          file = Pathname.new(s)
          keg.change_rpath(file, Keg::PREFIX_PLACEHOLDER, HOMEBREW_PREFIX.to_s) if file.mach_o_executable? || file.dylib?
        end
      end

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

    if build.bottle? || build.with?("test")
      resource("testsuite").stage { buildpath.install Dir["*"] }
      cd "testsuite" do
        system "make", "clean"
        system "make", "CLEANUP=1", "THREADS=#{ENV.make_jobs}", "fast"
      end
    end

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    system "#{bin}/runghc", testpath/"hello.hs"
    system "#{bin}/ghc", "-o", "hello", "hello.hs"
    system "./hello"
  end
end
