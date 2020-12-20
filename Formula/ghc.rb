class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.10.3/ghc-8.10.3-src.tar.xz"
  sha256 "ccdc8319549028a708d7163e2967382677b1a5a379ff94d948195b5cf46eb931"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "36daf8d12bf15ea04e12e9df4dc8a21de5ed01b39a3fd32ef3663ddb44a459fc" => :big_sur
    sha256 "1fc15705e5b9a24ca773d2df745345e75496ec3f227ea518d9945d6e1add6e18" => :catalina
    sha256 "cf8e2755d55d2a6479e4cebbee041ff63bece9bbae7d514c0b7601f6542b8081" => :mojave
    sha256 "40e2b31e3390cf784dedcd4357362bee577b6a5c1d911f5c072828fe01f42e8f" => :high_sierra
  end

  head do
    url "https://gitlab.haskell.org/ghc/ghc.git", branch: "ghc-8.10"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "cabal" do
      url "https://hackage.haskell.org/package/cabal-install-3.2.0.0/cabal-install-3.2.0.0.tar.gz"
      sha256 "a0555e895aaf17ca08453fde8b19af96725da8398e027aa43a49c1658a600cb0"
    end
  end

  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"
    mirror "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
    mirror "https://ftpmirror.gnu.org/gmp/gmp-6.2.1.tar.xz"
    sha256 "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2"
  end

  # https://www.haskell.org/ghc/download_ghc_8_10_1.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      url "https://downloads.haskell.org/~ghc/8.10.3/ghc-8.10.3-x86_64-apple-darwin.tar.xz"
      sha256 "2635f35d76e44e69afdfd37cae89d211975cc20f71f784363b72003e59f22015"
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/8.10.3/ghc-8.10.3-x86_64-deb9-linux.tar.xz"
      sha256 "95e4aadea30701fe5ab84d15f757926d843ded7115e11c4cd827809ca830718d"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    # Build a static gmp rather than in-tree gmp, otherwise all ghc-compiled
    # executables link to Homebrew's GMP.
    gmp = libexec/"integer-gmp"

    # GMP *does not* use PIC by default without shared libs so --with-pic
    # is mandatory or else you'll get "illegal text relocs" errors.
    resource("gmp").stage do
      system "./configure", "--prefix=#{gmp}", "--with-pic", "--disable-shared",
                            "--build=#{Hardware.oldest_cpu}-apple-darwin#{OS.kernel_version.major}"
      system "make"
      system "make", "install"
    end

    args = ["--with-gmp-includes=#{gmp}/include",
            "--with-gmp-libraries=#{gmp}/lib"]

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
    Dir.glob(lib/"*/package.conf.d/package.cache.lock") { |f| rm f }
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
