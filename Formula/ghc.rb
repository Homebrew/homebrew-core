class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.0.1/ghc-8.0.1-src.tar.xz"
  sha256 "90fb20cd8712e3c0fbeb2eac8dab6894404c21569746655b9b12ca9684c7d1d2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e254aa7b16e741e5d89893a7df1213a2bd6981419b9b7ce522276b4de5c9744c" => :sierra
    sha256 "210f5b5e8d223cc58689289e651fc6f2a3a9276e08a97eb8b9e2ea73e37718c5" => :el_capitan
    sha256 "854bec85cc5fb00ea0b9dd22d260294f4d2927fcee962d2c3b6804765f012f52" => :yosemite
    sha256 "d7ac762642463f397ec2edb5cde43b6f573293474fd989ac7f49aaa1e0d8f25e" => :mavericks
  end

  option "with-test", "Verify the build using the testsuite"
  option "without-docs", "Do not build documentation (including man page)"
  deprecated_option "tests" => "with-test"
  deprecated_option "with-tests" => "with-test"

  depends_on :macos => :lion
  depends_on "sphinx-doc" => :build if build.with? "docs"

  resource "gmp" do
    url "https://ftpmirror.gnu.org/gmp/gmp-6.1.0.tar.bz2"
    mirror "https://gmplib.org/download/gmp/gmp-6.1.0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.0.tar.bz2"
    sha256 "498449a994efeba527885c10405993427995d3f86b8768d8cdf8d9dd7c6b73e8"
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
  # "This is a distribution for macOS, 10.7 or later."
  resource "binary" do
    url "https://downloads.haskell.org/~ghc/8.0.1/ghc-8.0.1-x86_64-apple-darwin.tar.xz"
    sha256 "06ec33056b927da5e68055147f165f873088f6812fe0c642c4c78c9a449fbc42"
  end

  resource "testsuite" do
    url "https://downloads.haskell.org/~ghc/8.0.1/ghc-8.0.1-testsuite.tar.xz"
    sha256 "bc57163656ece462ef61072559d491b72c5cdd694f3c39b80ac0f6b9a3dc8151"
  end

  # fix clock_gettime support on 10.12
  # https://ghc.haskell.org/trac/ghc/ticket/12195
  if MacOS.version >= :sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/9eef46168ca5daa1629082af5532fc4b521d1a8d/ghc/clock_gettime.patch"
      sha256 "42444b381840d9d90202ff619f0070c28a753243af5d7e6b60efd227c6cf308c"
    end
  end

  def install
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
            "--with-gcc=#{ENV.cc}"] # Always.

    if ENV.compiler == :clang
      args << "--with-clang=#{ENV.cc}"
    elsif ENV.compiler == :llvm
      args << "--with-gcc-4.2=#{ENV.cc}"
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
    args << "--with-nm=#{`xcrun --find nm-classic`.chomp}" if DevelopmentTools.clang_build_version >= 703

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
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
  end
end
