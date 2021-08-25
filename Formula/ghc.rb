class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.10.6/ghc-8.10.6-src.tar.xz"
  sha256 "43afba72a533408b42c1492bd047b5e37e5f7204e41a5cedd3182cc841610ce9"
  # We bundle a static GMP so GHC inherits GMP's license
  license all_of: [
    "BSD-3-Clause",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(8(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4e9b7b6632e78c4224aff6cb5a6eaaffd8c0f6d8e78f8b531dc3d171662a1d2c"
    sha256                               big_sur:       "a6cf3b392bffa87b860cf42966015e00707f8bb559c8cad27b76a55d4f12af23"
    sha256                               catalina:      "735ab8edd2fd0c4ca7b5ef8763bff6579647e562fb819b42d319b1561bef70a5"
    sha256                               mojave:        "babf59ed8241f90f695d99c9f0e6c6180c738dbf092e70e40cbf6d92e385f059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3df2ff118d2c5a6b34df20fac8a317240f70809e8e0fb7a6a91c06e876ddf7d"
  end

  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build
  depends_on "llvm" if Hardware::CPU.arm?

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  on_macos do
    resource "gmp" do
      url "https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"
      mirror "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
      mirror "https://ftpmirror.gnu.org/gmp/gmp-6.2.1.tar.xz"
      sha256 "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2"
    end
  end

  on_linux do
    depends_on "gmp" => :build
  end

  # https://www.haskell.org/ghc/download_ghc_8_10_6.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      if Hardware::CPU.intel? && MacOS.version > :mojave
        url "https://downloads.haskell.org/~ghc/8.10.6/ghc-8.10.6-x86_64-apple-darwin.tar.xz"
        sha256 "32ab41da04d56cae2297d6e45caa88180f99cec0e33f2756cfbc48c0c60b5721"
      elsif Hardware::CPU.intel? && MacOS.version <= :mojave
        # We intentionally bootstrap with 8.10.4 on Intel, as 8.10.{5,6} leads to build failure on Mojave
        # ref: https://github.com/Homebrew/homebrew-core/pull/78821#issuecomment-857718840
        url "https://downloads.haskell.org/~ghc/8.10.4/ghc-8.10.4-x86_64-apple-darwin.tar.xz"
        sha256 "725ecf6543e63b81a3581fb8c97afd21a08ae11bc0fa4f8ee25d45f0362ef6d5"
      else
        url "https://downloads.haskell.org/ghc/8.10.6/ghc-8.10.6-aarch64-apple-darwin.tar.xz"
        sha256 "9e43fc3a39d2f2762262c63868653984e381e29eff6386f7325aad501b9190ad"
      end
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/8.10.6/ghc-8.10.6-x86_64-deb9-linux.tar.xz"
      sha256 "c14b631437ebc867f1fe1648579bc1dbe1a9b9ad31d7c801c3c77639523a83ae"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    args = %w[--enable-numa=no]
    on_macos do
      # Build a static gmp rather than in-tree gmp, otherwise all ghc-compiled
      # executables link to Homebrew's GMP.
      gmp = libexec/"integer-gmp"

      # GMP *does not* use PIC by default without shared libs so --with-pic
      # is mandatory or else you'll get "illegal text relocs" errors.
      resource("gmp").stage do
        cpu = Hardware::CPU.arm? ? "aarch64" : Hardware.oldest_cpu
        system "./configure", "--prefix=#{gmp}", "--with-pic", "--disable-shared",
                              "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"
        system "make"
        system "make", "install"
      end

      args = ["--with-gmp-includes=#{gmp}/include",
              "--with-gmp-libraries=#{gmp}/lib"]
    end

    resource("binary").stage do
      binary = buildpath/"binary"

      binary_args = args
      on_linux do
        binary_args << "--with-gmp-includes=#{Formula["gmp"].opt_include}"
        binary_args << "--with-gmp-libraries=#{Formula["gmp"].opt_lib}"
      end

      system "./configure", "--prefix=#{binary}", *binary_args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    on_linux do
      args << "--with-intree-gmp"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
    Dir.glob(lib/"*/package.conf.d/package.cache.lock") { |f| rm f }

    bin.env_script_all_files libexec/"bin", PATH: "$PATH:#{Formula["llvm"].opt_bin}" if Hardware::CPU.arm?
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
