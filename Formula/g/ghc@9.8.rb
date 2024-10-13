class GhcAT98 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-src.tar.xz"
  sha256 "e2fb7a7dd7461237d22e8365a83edd9e1a77d2e15d045f3945396845a87781c9"
  # We build bundled copies of libffi and GMP so GHC inherits the licenses
  license all_of: [
    "BSD-3-Clause",
    "MIT", # libffi
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"], # GMP
  ]

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(9\.8(?:\.\d+)+)\s*?</i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "2d815b4bf0d5873313ad00c7bcc2c3a8c3a14892edcb76ae87a8abfcb92bc119"
    sha256 cellar: :any,                 arm64_sonoma:   "abeced6f03bc0d63eaaa0909167c4cda1585c414e718861ec89aa0f13122a6d5"
    sha256 cellar: :any,                 arm64_ventura:  "686beedac05e51b8554a6fbdd44ea4a06b5fc5f73cd18ddb5191dee9d8ed1965"
    sha256 cellar: :any,                 arm64_monterey: "263c6cc8f81369500e6270509468775976987c5557f023126e694c00d7f44ba6"
    sha256 cellar: :any,                 sonoma:         "64216a95d4b33e2bde661c2fcadc50dc0bcebf09e4279db09b35b7f71b99c6f6"
    sha256 cellar: :any,                 ventura:        "6905add83dbe5b32468bd06c88ba8f34a6d59bffad1b077ea68ddb74507bf1e2"
    sha256 cellar: :any,                 monterey:       "a06fc3f77af7df2c5d37e2b2783bcd3174ad1287a939b38c8d6ba2941ee776a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0427565c4f24eac5d9eb39fb0f2bd9440cd52011f1c2621d70a511efa13d58e"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.12" => :build
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
        url "https://downloads.haskell.org/~ghc/9.6.6/ghc-9.6.6-aarch64-apple-darwin.tar.xz"
        sha256 "9134047605401bad08d8a845bce92acf225154753cfc8bddf0a2abaa86f4af42"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.6.6/ghc-9.6.6-x86_64-apple-darwin.tar.xz"
        sha256 "b6704410dd93ba3037655abfb5a4d5ce0dbff81ab787dbf862ee2fcf79df62dc"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.6.6/ghc-9.6.6-aarch64-deb10-linux.tar.xz"
        sha256 "58d5ce65758ec5179b448e4e1a2f835924b4ada96cf56af80d011bed87d91fef"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.6.6/ghc-9.6.6-x86_64-ubuntu20_04-linux.tar.xz"
        sha256 "f6377a88e1e58b74682345b04401dd20386de43cb37f027f4b54216db7bed5f9"
      end
    end
  end

  resource "cabal-install" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-aarch64-darwin.tar.xz"
        sha256 "9c165ca9a2e593b12dbb0eca92c0b04f8d1c259871742d7e9afc352364fe7a3f"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-x86_64-darwin.tar.xz"
        sha256 "e89392429f59bbcfaf07e1164e55bc63bba8e5c788afe43c94e00b515c1578af"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-aarch64-linux-deb10.tar.xz"
        sha256 "c01f2e0b3ba1fe4104cf2933ee18558a9b81d85831a145e8aba33fa172c7c618"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-x86_64-linux-ubuntu20_04.tar.xz"
        sha256 "3724f2aa22f330c5e6605978f3dd9adee4e052866321a8dd222944cd178c3c24"
      end
    end
  end

  # Backport fix for autoconf 2.72.
  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/c9731d6d3cad01fccb88c99c4f26070a44680389.diff"
    sha256 "f7e921f7096c97bd4e63ac488186a132eb0cc508d04f0c5a99e9ded51bf16b25"
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
    ENV["LD"] = "ld"
    ENV["PYTHON"] = which("python3.12")

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
    # Work around linkage error due to RPATH in ghc-iserv-dyn-ghc
    # Issue ref: https://gitlab.haskell.org/ghc/ghc/-/issues/22557
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    cpu = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch.to_s
    extra_rpath = rpath(source: lib/"ghc-#{version}/bin",
                        target: lib/"ghc-#{version}/lib/#{cpu}-#{os}-ghc-#{version}")
    hadrian_args << "*.iserv.ghc.link.opts += -optl-Wl,-rpath,#{extra_rpath}"
    # Let hadrian handle its own parallelization
    ENV.deparallelize { system "hadrian/build", "install", *hadrian_args }

    bash_completion.install "utils/completion/ghc.bash" => "ghc"
    (lib/"ghc-#{version}/lib/package.conf.d/package.cache").unlink
    (lib/"ghc-#{version}/lib/package.conf.d/package.cache.lock").unlink
  end

  def post_install
    system bin/"ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
