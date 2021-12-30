class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-src.tar.xz"
  sha256 "140e42b96346322d1a39eb17602bcdc76e292028ad4a69286b230bab188a9197"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(9(?:\.\d+)+)\s*?</i)
  end

  depends_on "python@3.10" => :build
  depends_on "sphinx-doc" => :build
  # GHC 9.0.2 user manual recommend use LLVM 9 through 12
  # https://downloads.haskell.org/~ghc/9.0.2/docs/html/users_guide/9.0.2-notes.html
  # and we met some unknown issue w/ LLVM 13 before https://gitlab.haskell.org/ghc/ghc/-/issues/20559
  # so conservatively use LLVM 12 here
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
        url "https://downloads.haskell.org/ghc/9.0.2/ghc-9.0.2-aarch64-apple-darwin.tar.xz"
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
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    # https://gitlab.haskell.org/ghc/ghc/-/issues/20592#note_391266
    ENV["C_INCLUDE_PATH"] = `xcrun --show-sdk-path`.strip + "/usr/include/ffi" if Hardware::CPU.arm? && OS.mac?

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

    bin.env_script_all_files libexec, PATH: "${PATH}:#{Formula["llvm@12"].opt_bin}" if Hardware::CPU.arm?
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
