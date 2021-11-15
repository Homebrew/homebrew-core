class GhcAT88 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.8.4/ghc-8.8.4-src.tar.xz"
  sha256 "f0505e38b2235ff9f1090b51f44d6c8efd371068e5a6bb42a2a6d8b67b5ffc2d"
  # We bundle a static GMP so GHC inherits GMP's license
  license all_of: [
    "BSD-3-Clause",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]
  revision 1

  bottle do
    rebuild 1
    sha256                               monterey:     "ab02ef2f511577a67b72983e39a86593bb58270c3c22a7b7879d38818e91571d"
    sha256                               big_sur:      "b099711b984463a32a073f49ec91e6034519a6140958a6603d3888e565ea2e4e"
    sha256                               catalina:     "38d4abf9ea7ce0ac4c928623a835f39d2d58e4ce8c66e58ff3e245b31d2948a9"
    sha256                               mojave:       "bfa78f1df75b3bd13aae44cd1ccc3a739d75cae0b93f0d060606a75fe1fe9a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aec20b68e9ab97e0e99a83d651612c4d453446c466a040d7fd320e67b54194de"
  end

  keg_only :versioned_formula

  depends_on "python@3.9" => :build
  depends_on arch: :x86_64

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  on_macos do
    resource "gmp" do
      url "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
      mirror "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
      mirror "https://ftpmirror.gnu.org/gmp/gmp-6.1.2.tar.xz"
      sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"
    end
  end

  on_linux do
    depends_on "gmp" => :build
  end

  # https://www.haskell.org/ghc/download_ghc_8_8_3.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      url "https://downloads.haskell.org/~ghc/8.8.3/ghc-8.8.3-x86_64-apple-darwin.tar.xz"
      sha256 "7016de90dd226b06fc79d0759c5d4c83c2ab01d8c678905442c28bd948dbb782"
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/8.8.3/ghc-8.8.3-x86_64-deb8-linux.tar.xz"
      sha256 "92b9fadc442976968d2c190c14e000d737240a7d721581cda8d8741b7bd402f0"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"

    args = %w[--enable-numa=no]
    if OS.mac?
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

    # Disable PDF document generation (fails with newest sphinx)
    (buildpath/"mk/build.mk").write <<-EOS
      BUILD_SPHINX_PDF = NO
    EOS

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
