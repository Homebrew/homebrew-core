class GhcAT810 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.10.7/ghc-8.10.7-src.tar.xz"
  sha256 "e3eef6229ce9908dfe1ea41436befb0455fefb1932559e860ad4c606b0d03c9d"
  # We bundle a static GMP so GHC inherits GMP's license
  license all_of: [
    "BSD-3-Clause",
    "MIT", # libffi
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"], # GMP
  ]

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(8\.10(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5af941f345ced100c706b50beb3c1dfc0d88882aaa5dec2c403561f15def895f"
    sha256 cellar: :any,                 arm64_big_sur:  "57662ecdde5b435ad10fa13730d176d84f056ab81ca42f016dd1b1d4da625636"
    sha256                               ventura:        "53bab010a1307897f01d5a9b3884d274e6c07419a2f166b61b53026deffe36c5"
    sha256                               monterey:       "367dc6f9c22ba5586f63d4336740f6469d3383de1ecd7c0b2f505ca373c2e078"
    sha256                               big_sur:        "6d50644761eafb44fcded63cde90eb0e486e69bfdcb36047b001de60cce35c77"
    sha256                               catalina:       "a6b9bda281fc697f5e7ea5811836fc24be317608944f621e01914d4cd8e3349f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b7294dd5ad9ea5e2c30755cc532a868fb041c598fad0a306b82cbf1732200ce"
  end

  keg_only :versioned_formula

  depends_on "python@3.10" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "gmp" => :build
  end

  # GHC 8.10.7 user manual recommend use LLVM 9 through 12
  # https://downloads.haskell.org/~ghc/8.10.7/docs/html/users_guide/8.10.7-notes.html
  # and we met some unknown issue w/ LLVM 13 before https://gitlab.haskell.org/ghc/ghc/-/issues/20559
  # so conservatively use LLVM 12 here
  on_arm do
    depends_on "llvm@12"
  end

  resource "gmp" do
    on_macos do
      url "https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"
      mirror "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
      mirror "https://ftpmirror.gnu.org/gmp/gmp-6.2.1.tar.xz"
      sha256 "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2"
    end
  end

  # https://www.haskell.org/ghc/download_ghc_8_10_7.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      on_intel do
        url "https://downloads.haskell.org/~ghc/8.10.7/ghc-8.10.7-x86_64-apple-darwin.tar.xz"
        sha256 "287db0f9c338c9f53123bfa8731b0996803ee50f6ee847fe388092e5e5132047"
      end
      on_arm do
        url "https://downloads.haskell.org/ghc/8.10.7/ghc-8.10.7-aarch64-apple-darwin.tar.xz"
        sha256 "dc469fc3c35fd2a33a5a575ffce87f13de7b98c2d349a41002e200a56d9bba1c"
      end
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/8.10.7/ghc-8.10.7-x86_64-deb10-linux.tar.xz"
      sha256 "a13719bca87a0d3ac0c7d4157a4e60887009a7f1a8dbe95c4759ec413e086d30"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = which("python3.10")

    args = []
    if OS.mac?
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
      if OS.linux?
        binary_args << "--with-gmp-includes=#{Formula["gmp"].opt_include}"
        binary_args << "--with-gmp-libraries=#{Formula["gmp"].opt_lib}"
      end

      system "./configure", "--prefix=#{binary}", *binary_args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    args << "--with-intree-gmp" if OS.linux?

    system "./configure", "--prefix=#{prefix}", "--disable-numa", *args
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
