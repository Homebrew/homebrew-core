require "language/haskell"

class Ghc < Formula
  include Language::Haskell::Cabal

  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  if MacOS.version >= :sierra
    url "https://downloads.haskell.org/~ghc/8.0.2-rc1/ghc-8.0.1.20161117-src.tar.xz"
    sha256 "e4a036d1f8e7043dbefb08cd76d69cf44e672307ed595aed040aa602defe1722"
    version "8.0.1"
  else
    url "https://downloads.haskell.org/~ghc/8.0.1/ghc-8.0.1-src.tar.xz"
    sha256 "90fb20cd8712e3c0fbeb2eac8dab6894404c21569746655b9b12ca9684c7d1d2"
  end
  revision 3

  bottle do
    sha256 "066bebe5c79970838bd589aed33ef209695eb86189c693378bd6fbcc6e47accb" => :sierra
    sha256 "5f56a89c44c750fc8b1a3c93b66eb2c5e92c58455e215c4f8f2c5ba0f350d7b3" => :el_capitan
    sha256 "b5b5307ffc223b4ff5946cbe6fa08eef881f8f92c91dc3449ef225d8190a0abe" => :yosemite
    sha256 "4f9d9756e2562da99c825103fb90c0d833f67bc681d7d71ec46c059028b3badf" => :x86_64_linux
  end

  head do
    url "https://git.haskell.org/ghc.git", :branch => "ghc-8.0"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "cabal" do
      url "https://hackage.haskell.org/package/cabal-install-1.24.0.0/cabal-install-1.24.0.0.tar.gz"
      sha256 "d840ecfd0a95a96e956b57fb2f3e9c81d9fc160e1fd0ea350b0d37d169d9e87e"
    end

    # disables haddock for hackage-security
    resource "cabal-patch" do
      url "https://github.com/haskell/cabal/commit/9441fe.patch"
      sha256 "5506d46507f38c72270efc4bb301a85799a7710804e033eaef7434668a012c5e"
    end
  end

  option "with-test", "Verify the build using the testsuite"
  option "without-docs", "Do not build documentation (including man page)"
  deprecated_option "tests" => "with-test"
  deprecated_option "with-tests" => "with-test"

  depends_on :macos => :lion
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "homebrew/dupes/m4" => :build unless OS.mac?
  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  # This dependency is needed for the bootstrap executables.
  depends_on "gmp" => :build if OS.linux?

  resource "gmp" do
    url "https://ftpmirror.gnu.org/gmp/gmp-6.1.1.tar.xz"
    mirror "https://gmplib.org/download/gmp/gmp-6.1.1.tar.xz"
    mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.1.tar.xz"
    sha256 "d36e9c05df488ad630fff17edb50051d6432357f9ce04e34a09b3d818825e831"
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
    elsif MacOS.version >= :sierra
      url "https://downloads.haskell.org/~ghc/8.0.2-rc1/ghc-8.0.1.20161117-x86_64-apple-darwin.tar.xz"
      sha256 "6086ac08be3733c8817328c99c4af66f5a2feba02d4be4b0dc0aeac5acf0360e"
    else
      url "https://downloads.haskell.org/~ghc/8.0.1/ghc-8.0.1-x86_64-apple-darwin.tar.xz"
      sha256 "06ec33056b927da5e68055147f165f873088f6812fe0c642c4c78c9a449fbc42"
    end
  end

  resource "testsuite" do
    if MacOS.version >= :sierra
      url "http://downloads.haskell.org/~ghc/8.0.2-rc1/ghc-8.0.1.20161117-testsuite.tar.xz"
      sha256 "c3da1333a10d71eb5a0d08391c08c2205d8ca10cb39261964bbcbd745d9277dd"
    else
      url "https://downloads.haskell.org/~ghc/8.0.1/ghc-8.0.1-testsuite.tar.xz"
      sha256 "bc57163656ece462ef61072559d491b72c5cdd694f3c39b80ac0f6b9a3dc8151"
    end
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
    elsif ENV.compiler == :llvm
      args << "--with-gcc-4.2=#{ENV.cc}"
    end

    if OS.linux?
      # Fix error while loading shared libraries: libgmp.so.3
      ln_s Formula["gmp"].lib/"libgmp.so", gmp/"lib/libgmp.so.3"
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
    args << "--with-nm=#{`xcrun --find nm-classic`.chomp}" if OS.mac? && DevelopmentTools.clang_build_version >= 703

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
        Pathname.pwd.install resource("cabal-patch")
        system "patch", "-p2", "-i", "9441fe.patch"
        system "sh", "bootstrap.sh", "--sandbox", "--no-doc"
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
