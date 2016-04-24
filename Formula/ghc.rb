class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3b-src.tar.bz2"
  sha256 "b0bb177b8095de6074e5a3538e55fd1fc187dae6eb6ae36b05582c55f7d2db6f"

  bottle do
    cellar :any
    revision 2
    sha256 "35f640eb0f58ef517a829bfdbc046a03c84e179fb2100421b9b0c8dbc1f18e2a" => :el_capitan
    sha256 "6ac060e495d6373ed9051da8ba55bcab2d51f30ebf9f68a48f842171ee5181a6" => :yosemite
    sha256 "0f846d17016873ebf740729844286978f9673982fe686a5308ee4cd444de59cb" => :mavericks
  end

  option "with-test", "Verify the build using the testsuite"
  deprecated_option "tests" => "with-test"
  deprecated_option "with-tests" => "with-test"

  resource "gmp" do
    url "http://ftpmirror.gnu.org/gmp/gmp-6.1.0.tar.bz2"
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

  resource "binary" do
    if MacOS.version <= :lion
      url "https://downloads.haskell.org/~ghc/7.6.3/ghc-7.6.3-x86_64-apple-darwin.tar.bz2"
      sha256 "f7a35bea69b6cae798c5f603471a53b43c4cc5feeeeb71733815db6e0a280945"
    else
      url "https://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3-x86_64-apple-darwin.tar.xz"
      sha256 "852781d43d41cd55d02f818fe798bb4d1f7e52f488408167f413f7948cf1e7df"
    end
  end

  resource "testsuite" do
    url "https://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3-testsuite.tar.xz"
    sha256 "50c151695c8099901334a8478713ee3bb895a90132e2b75d1493961eb8ec643a"
  end

  def install
    # As of Xcode 7.3 (and the corresponding CLT) `nm` is a symlink to `llvm-nm`
    # and the old `nm` is renamed `nm-classic`. Building with the new `nm`, a
    # segfault occurs with the following error:
    #   make[1]: * [compiler/stage2/dll-split.stamp] Segmentation fault: 11
    # Upstream is aware of the issue and is recommending the use of nm-classic
    # until Apple and LLVM restore POSIX compliance:
    # https://ghc.haskell.org/trac/ghc/ticket/11744
    # https://ghc.haskell.org/trac/ghc/ticket/11823
    # https://mail.haskell.org/pipermail/ghc-devs/2016-April/011862.html
    if MacOS.clang_build_version >= 703
      nm_classic = buildpath/"brewtools/nm"

      nm_classic.write <<-EOS.undent
        #!/bin/bash
        exec xcrun nm-classic "$@"
      EOS

      chmod 0755, nm_classic
      ENV.prepend_path "PATH", buildpath/"brewtools"
    end

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

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    if build.with? "test"
      resource("testsuite").stage { buildpath.install Dir["*"] }
      cd "testsuite" do
        system "make", "clean"
        system "make", "CLEANUP=1", "THREADS=#{ENV.make_jobs}", "fast"
      end
    end

    ENV.deparallelize { system "make", "install" }
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    system "#{bin}/runghc", testpath/"hello.hs"
  end
end
