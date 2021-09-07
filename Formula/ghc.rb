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

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(8(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "dc95f7ac96f96622d0ba846d38355f944e16a4c06304a12f5549dde9de422c3d"
    sha256                               big_sur:       "c008431d9fdd2d56c97cd22134c776c9e2c3f322a4e8ebb9bb5808750c7ce1c2"
    sha256                               catalina:      "9d7309d7f86d20b3c1d7c3ec74f7c77b060910b52d3550c2f6f17312da0d0d47"
    sha256                               mojave:        "6f23a42bf1ad6b4ef103c29c09033117e27dbd85f752cdcdc33220cfd505c445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ea70cb015d4f7d1c7aa25cca023b93dd254173964f6497ead92dda3602b961c"
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
