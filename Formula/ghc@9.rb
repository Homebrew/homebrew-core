class GhcAT9 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.2.2/ghc-9.2.2-src.tar.xz"
  sha256 "902463a4cc6ee479af9358b9f8b2ee3237b03e934a1ea65b6d1fcf3e0d749ea6"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(\d+(?:\.\d+)+)\s*?</i)
  end

  bottle do
    rebuild 1
    sha256 monterey: "a68d3bd94035ca937a774c26a430249c084cee19e4c28a2727e02bcd9122e76f"
    sha256 big_sur:  "167ea0c28443596500a924e7a646a68a599b08ae8f8ffe53d09f0d6c98ff2d58"
    sha256 catalina: "9fee2bc2c5e9518ece84356ada1aa2c360fbbaea87ed59bed8f664078c25f8a1"
  end

  keg_only :versioned_formula

  depends_on "python@3.10" => :build
  depends_on "sphinx-doc" => :build

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

      system "./configure", "--prefix=#{binary}"
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--prefix=#{prefix}"
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
