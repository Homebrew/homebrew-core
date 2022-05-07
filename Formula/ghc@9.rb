class GhcAT9 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.2.3/ghc-9.2.3-src.tar.xz"
  sha256 "50ecdc2bef013e518f9a62a15245d7db0e4409d737c43b1cea7306fd82e1669e"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(\d+(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 monterey: "d1b4862f6ec80b498423dab73d60da81bcd5dfa4fb5569a69a5f5df6185f1d84"
    sha256 big_sur:  "d6158ca8d61870d78034503fa1a8a9490a6d2bdc0af1e03d3892a23b3f0c0352"
    sha256 catalina: "3f9c3a54bba1eb35b4575d8a20704f0e6d8d079b3f6ae9536b150255948f6e48"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gmp" => :build
  depends_on "libtool" => :build
  depends_on "python@3.10" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  # https://www.haskell.org/ghc/download_ghc_9_0_2.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-x86_64-apple-darwin.tar.xz"
      sha256 "e1fe990eb987f5c4b03e0396f9c228a10da71769c8a2bc8fadbc1d3b10a0f53a"
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-x86_64-deb9-linux.tar.xz"
      sha256 "805f5628ce6cec678ba77ff48c924831ebdf75ec2c66368e8935a618913a150e"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3"

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", "--with-gmp-includes=#{Formula["gmp"].opt_include}",
             "--with-gmp-libraries=#{Formula["gmp"].opt_lib}"
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./boot"
    system "./configure", "--prefix=#{prefix}", "--with-intree-gmp"
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
