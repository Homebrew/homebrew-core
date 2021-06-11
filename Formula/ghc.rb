class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.10.5/ghc-8.10.5-src.tar.xz"
  sha256 "f10941f16e4fbd98580ab5241b9271bb0851304560c4d5ca127e3b0e20e3076f"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(8(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5fb211bdab28a5f3f49796439c5d37637d8da68e9bcde04604b501e342945fc7"
    sha256               big_sur:       "8ed8d1104dc1ca16619434c380642bcfc65f85d01206a24b0e71a15c770a7457"
    sha256               catalina:      "17d7984c1afe40d2d9a92eb591b640539ef8cfeb04bad7b1f934ce84d8b85724"
    sha256               mojave:        "dd2289d325865bb59e8009f57c201f6e07a3efd2a435e3f8bd727cf959093df3"
  end

  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build
  depends_on "llvm" if Hardware::CPU.arm?

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
        # We intentionally bootstrap with 8.10.4 on Intel, as 8.10.5 leads to build failure on Mojave
        url "https://downloads.haskell.org/~ghc/8.10.4/ghc-8.10.4-x86_64-apple-darwin.tar.xz"
        sha256 "725ecf6543e63b81a3581fb8c97afd21a08ae11bc0fa4f8ee25d45f0362ef6d5"
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
    # Fix doc build error. Remove at version bump.
    # https://gitlab.haskell.org/ghc/ghc/-/issues/19962
    inreplace "docs/users_guide/conf.py" do |s|
      s.gsub! "'preamble': '''", "'preamble': r'''"
      s.gsub! "\\setlength{\\\\tymin}{45pt}", "\\setlength{\\tymin}{45pt}"
    end

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
