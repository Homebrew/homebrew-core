class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.12.1/ghc-9.12.1-src.tar.xz"
  sha256 "4a7410bdeec70f75717087b8f94bf5a6598fd61b3a0e1f8501d8f10be1492754"
  # We build bundled copies of libffi and GMP so GHC inherits the licenses
  license all_of: [
    "BSD-3-Clause",
    "MIT", # libffi
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"], # GMP
  ]
  head "https://gitlab.haskell.org/ghc/ghc.git", branch: "master"

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(\d+(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0cbc0801cb71cda95756b1926ee60ccfcff38a5113b0eedfbbae8f3bcbe03216"
    sha256 cellar: :any,                 arm64_sonoma:  "2b87f819d22a4f5dfb112dc02bcea4e9f7abefc792192b1623c5dfb2dedf488f"
    sha256 cellar: :any,                 arm64_ventura: "8a321896cc41c9cd2b626ddd87ac23dc10c6744da2fe2c445ae638b5f8eb7c03"
    sha256 cellar: :any,                 sonoma:        "a9ea60687b80e702b59a4435abe8938d8d73335655453ef1bf6c498ef900007f"
    sha256 cellar: :any,                 ventura:       "0415a4cda74b5b5377eb9e8711973af0b48953608453c3277a634178a4b78b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a582bb99457e8305100a0b452a51879b4ab029205e7fec58853fbf022bb2f157"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.13" => :build
  depends_on "sphinx-doc" => :build
  depends_on "xz" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  # Build uses sed -r option, which is not available in Catalina shipped sed.
  on_catalina :or_older do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "gmp" => :build
  end

  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.10.1/ghc-9.10.1-aarch64-apple-darwin.tar.xz"
        sha256 "ffaf83b5d7a8b2c04920c6e3909c0be21dde27baf380d095fa27e840a3a2e804"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.10.1/ghc-9.10.1-x86_64-apple-darwin.tar.xz"
        sha256 "8cf22188930e10d7ac5270d425e21a3dab606af73a655493639345200c650be9"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.10.1/ghc-9.10.1-aarch64-deb10-linux.tar.xz"
        sha256 "e6df50e62b696e3a8b759670fc79207ccc26e88a79a047561ca1ccb8846157dd"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.10.1/ghc-9.10.1-x86_64-ubuntu20_04-linux.tar.xz"
        sha256 "ae3be406fdb73bd2b0c22baada77a8ff2f8cde6220dd591dc24541cfe9d895eb"
      end
    end
  end

  resource "cabal-install" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.14.1.1/cabal-install-3.14.1.1-aarch64-darwin.tar.xz"
        sha256 "bd40920fb3d5bcf3d78ce93445039ba43bc5edf769c52234223f25b83e3cc682"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.14.1.1/cabal-install-3.14.1.1-x86_64-darwin.tar.xz"
        sha256 "3690d8f7aa368141574f9eaf8e75bc26932ed7b422f5ade107d6972b3b72532f"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.14.1.1/cabal-install-3.14.1.1-aarch64-linux-deb10.tar.xz"
        sha256 "bf5fbe5d911c771b1601b80b00e9f9fb3db7f800258204322e411fdf1661a866"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.14.1.1/cabal-install-3.14.1.1-x86_64-linux-ubuntu20_04.tar.xz"
        sha256 "91d2b65907e95462396fa96892ebbd903861fc07b5cb74993c612e33d4c0cc65"
      end
    end
  end

  def install
    # ENV.cc and ENV.cxx return specific compiler versions on Ubuntu, e.g.
    # gcc-11 and g++-11 on Ubuntu 22.04. Using such values effectively causes
    # the bottle (binary package) to only run on systems where gcc-11 and g++-11
    # binaries are available. This breaks on many systems including Arch Linux,
    # Fedora and Ubuntu 24.04, as they provide g** but not g**-11 specifically.
    #
    # The workaround here is to hard-code both CC and CXX on Linux.
    ENV["CC"] = ENV["ac_cv_path_CC"] = OS.linux? ? "cc" : ENV.cc
    ENV["CXX"] = ENV["ac_cv_path_CXX"] = OS.linux? ? "c++" : ENV.cxx
    ENV["LD"] = ENV["MergeObjsCmd"] = "ld"
    ENV["PYTHON"] = which("python3.13")

    binary = buildpath/"binary"
    resource("binary").stage do
      binary_args = []
      if OS.linux?
        binary_args << "--with-gmp-includes=#{Formula["gmp"].opt_include}"
        binary_args << "--with-gmp-libraries=#{Formula["gmp"].opt_lib}"
      end

      system "./configure", "--prefix=#{binary}", *binary_args
      ENV.deparallelize { system "make", "install" }
    end

    ENV.prepend_path "PATH", binary/"bin"
    # Build uses sed -r option, which is not available in Catalina shipped sed.
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac? && MacOS.version <= :catalina

    resource("cabal-install").stage { (binary/"bin").install "cabal" }
    system "cabal", "v2-update"
    if build.head?
      cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
      system "cabal", "v2-install", "alex", "happy", *cabal_args, "--installdir=#{binary}/bin"
      system "./boot"
    end

    args = []
    if OS.mac?
      # https://gitlab.haskell.org/ghc/ghc/-/issues/22595#note_468423
      args << "--with-ffi-libraries=#{MacOS.sdk_path_if_needed}/usr/lib"
      args << "--with-ffi-includes=#{MacOS.sdk_path_if_needed}/usr/include/ffi"
      args << "--with-system-libffi"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-numa", "--with-intree-gmp", *args
    hadrian_args = %W[
      -j#{ENV.make_jobs}
      --prefix=#{prefix}
      --flavour=release
      --docs=no-sphinx-pdfs
    ]
    # Let hadrian handle its own parallelization
    ENV.deparallelize { system "hadrian/build", "install", *hadrian_args }

    bash_completion.install "utils/completion/ghc.bash" => "ghc"
    ghc_libdir = build.head? ? lib.glob("ghc-*").first : lib/"ghc-#{version}"
    (ghc_libdir/"lib/package.conf.d/package.cache").unlink
    (ghc_libdir/"lib/package.conf.d/package.cache.lock").unlink
  end

  def post_install
    system bin/"ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
