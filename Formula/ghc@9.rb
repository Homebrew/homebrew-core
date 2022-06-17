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
    sha256                               monterey:     "aa86fcfbce23f51967c7e92a6743eb88078dc207bd833803fa02a755d1de3dd2"
    sha256                               big_sur:      "f1964952d6f405cb1723dcc717e9771f7f5d8f13c7b0ab7a5ac6a508510cdd6f"
    sha256                               catalina:     "ffeb2f809633faa330b6ff84f72bf06f9be5af3029f8f94f2df5a38788c54142"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9e8d684c4138d0738328bf3e8ec6d89a17f0cdeb5ddd9b44ef60011548522562"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gmp" => :build
  depends_on "libtool" => :build
  depends_on "python@3.10" => :build
  depends_on "sphinx-doc" => :build
  depends_on "llvm@12" if Hardware::CPU.arm?

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  # https://www.haskell.org/ghc/download_ghc_9_0_2.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-x86_64-apple-darwin.tar.xz"
        sha256 "e1fe990eb987f5c4b03e0396f9c228a10da71769c8a2bc8fadbc1d3b10a0f53a"
      else
        url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-aarch64-apple-darwin.tar.xz"
        sha256 "b1fcab17fe48326d2ff302d70c12bc4cf4d570dfbbce68ab57c719cfec882b05"
      end
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
    # Work around build failure: fatal error: 'ffitarget_arm64.h' file not found
    # Issue ref: https://gitlab.haskell.org/ghc/ghc/-/issues/20592
    # TODO: remove once bootstrap ghc is 9.2.3 or later.
    ENV.append_path "C_INCLUDE_PATH", "#{MacOS.sdk_path_if_needed}/usr/include/ffi" if OS.mac? && Hardware::CPU.arm?

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

    bin.env_script_all_files libexec, PATH: "$PATH:#{Formula["llvm@12"].opt_bin}" if Hardware::CPU.arm?
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
