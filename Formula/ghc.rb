require "language/haskell"

class Ghc < Formula
  include Language::Haskell::Cabal

  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  revision 2

  stable do
    if MacOS.version >= :sierra
      url "https://git.haskell.org/ghc.git",
          :revision => "ee3ff0d21fd51af269a29d371db0094397090bc8"
      version "8.0.1"

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
    else
      url "https://downloads.haskell.org/~ghc/8.0.1/ghc-8.0.1-src.tar.xz"
      sha256 "90fb20cd8712e3c0fbeb2eac8dab6894404c21569746655b9b12ca9684c7d1d2"
    end
  end

  bottle do
    sha256 "fdd521d61017c4a2068d24b3386c85266f68cbb56d5b88d392c17cb2f3bfd197" => :sierra
    sha256 "4ba5955be4502877ab9fc7c748209d81680ada0dd127284c423f1af53553b66d" => :el_capitan
    sha256 "b023ec943f8aae7ed0c11687c8fa277d6f23d41a4771b8b3a695cc6833c8e593" => :yosemite
  end

  option "with-test", "Verify the build using the testsuite"
  option "without-docs", "Do not build documentation (including man page)"
  deprecated_option "tests" => "with-test"
  deprecated_option "with-tests" => "with-test"

  depends_on :macos => :lion
  depends_on "sphinx-doc" => :build if build.with? "docs"

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
    url "https://downloads.haskell.org/~ghc/8.0.1/ghc-8.0.1-x86_64-apple-darwin.tar.xz"
    sha256 "06ec33056b927da5e68055147f165f873088f6812fe0c642c4c78c9a449fbc42"
  end

  resource "testsuite" do
    url "https://downloads.haskell.org/~ghc/8.0.1/ghc-8.0.1-testsuite.tar.xz"
    sha256 "bc57163656ece462ef61072559d491b72c5cdd694f3c39b80ac0f6b9a3dc8151"
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
    if DevelopmentTools.clang_build_version >= 703 && DevelopmentTools.clang_build_version < 800
      args << "--with-nm=#{`xcrun --find nm-classic`.chomp}"
    end

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    if MacOS.version == :sierra
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
  end
end
