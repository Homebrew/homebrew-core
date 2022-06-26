class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.10.7/ghc-8.10.7-src.tar.xz"
  sha256 "e3eef6229ce9908dfe1ea41436befb0455fefb1932559e860ad4c606b0d03c9d"
  # We bundle a static GMP so GHC inherits GMP's license
  license all_of: [
    "BSD-3-Clause",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]
  revision 1

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(8(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "41e846a0479f930390ae2c65cf7ae0f3ea3755ff26df56822fb999722fb4932e"
    sha256 cellar: :any,                 arm64_big_sur:  "7ddd8e8dabdb5654f167aa079ef9a1290e20aa151ce3580eed24042d95d47b57"
    sha256                               monterey:       "c50034c3553a0f6099e2dfc3c7c33ca148256fedc8bc9be492cc942284bb473e"
    sha256                               big_sur:        "68f447996de80ef0aa655b9b0f5cc048503a09366b17edf77b101f9c1a38fe0b"
    sha256                               catalina:       "14f6f4c4faa2ef0e4de7b225346c3b084de3356f069ac77eed05768046c70e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea0a8011b453e37e99855a6640642303d60c6611db366cb5f2d02a7546da19b"
  end

  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build
  # GHC 8.10.7 user manual recommend use LLVM 9 through 12
  # https://downloads.haskell.org/~ghc/8.10.7/docs/html/users_guide/8.10.7-notes.html
  # and we met some unknown issue w/ LLVM 13 before https://gitlab.haskell.org/ghc/ghc/-/issues/20559
  # so conservatively use LLVM 12 here
  depends_on "llvm@12" if Hardware::CPU.arm?

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

  # https://www.haskell.org/ghc/download_ghc_8_10_7.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://downloads.haskell.org/~ghc/8.10.7/ghc-8.10.7-x86_64-apple-darwin.tar.xz"
        sha256 "287db0f9c338c9f53123bfa8731b0996803ee50f6ee847fe388092e5e5132047"
      else
        url "https://downloads.haskell.org/ghc/8.10.7/ghc-8.10.7-aarch64-apple-darwin.tar.xz"
        sha256 "dc469fc3c35fd2a33a5a575ffce87f13de7b98c2d349a41002e200a56d9bba1c"
      end
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/8.10.7/ghc-8.10.7-x86_64-deb9-linux.tar.xz"
      sha256 "ced9870ea351af64fb48274b81a664cdb6a9266775f1598a79cbb6fdd5770a23"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    args = %w[--enable-numa=no]
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

    system "./configure", "--prefix=#{prefix}", *args
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
