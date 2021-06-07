class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.10.5/ghc-8.10.5-src.tar.xz"
  sha256 "f10941f16e4fbd98580ab5241b9271bb0851304560c4d5ca127e3b0e20e3076f"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(8(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 big_sur:  "965f94c14b56e3db7b239860e0a1d577be0b27caf8adb6212710a7430ce723d3"
    sha256 catalina: "9a4f6c3edf83d5e2020bee5c3dd419bb6c3ebb5988306be9ffeca6bb7810d1f8"
    sha256 mojave:   "5230b93b929e970b68aa6778ebd717c32ca08448c3428f97650e4f707c022ed5"
  end

  depends_on "python@3.9" => :build
  depends_on "llvm" if Hardware::CPU.arm?
  depends_on macos: :catalina

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"
    mirror "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
    mirror "https://ftpmirror.gnu.org/gmp/gmp-6.2.1.tar.xz"
    sha256 "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2"
  end

  # https://www.haskell.org/ghc/download_ghc_8_10_4.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://downloads.haskell.org/~ghc/8.10.5/ghc-8.10.5-x86_64-apple-darwin.tar.xz"
        sha256 "ef0f47eff8962d58fa447123636cf8ef31c1e5b2d0ae90177d3388861ddf4a22"
      else
        url "https://downloads.haskell.org/ghc/8.10.5/ghc-8.10.5-aarch64-apple-darwin.tar.xz"
        sha256 "03684e70ff03d041b9a4e0f84c177953a241ab8ec7a028c72fa21ac67e66cb09"
      end
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/8.10.5/ghc-8.10.5-x86_64-deb9-linux.tar.xz"
      sha256 "15e71325c3bdfe3804be0f84c2fc5c913d811322d19b0f4d4cff20f29cdd804d"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

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

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make", "BUILD_SPHINX_HTML=NO"

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
