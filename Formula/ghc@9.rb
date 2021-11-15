class GhcAT9 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.2.1/ghc-9.2.1-src.tar.xz"
  sha256 "f444012f97a136d9940f77cdff03fda48f9475e2ed0fec966c4d35c4df55f746"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(\d+(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 monterey: "fcd1e8069f6573791942533a04967ba442fccbbb3b642e6a7c9d4aa8be140050"
    sha256 big_sur:  "1288aa3c699c68df305664247e9424df9d7e319978f843de2be8ca9a35c257c0"
    sha256 catalina: "213e19e4cef177418d6b7cfbe9df601a051de2704a02727f22e5bf208f487ef8"
  end

  keg_only :versioned_formula

  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build

  # https://www.haskell.org/ghc/download_ghc_9_0_1.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      url "https://downloads.haskell.org/~ghc/9.0.1/ghc-9.0.1-x86_64-apple-darwin.tar.xz"
      sha256 "122d60509147d0117779d275f0215bde2ff63a64cda9d88f149432d0cae71b22"
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/9.0.1/ghc-9.0.1-x86_64-deb9-linux.tar.xz"
      sha256 "4ca6252492f59fe589029fadca4b6f922d6a9f0ff39d19a2bd9886fde4e183d5"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

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
