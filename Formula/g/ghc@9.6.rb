class GhcAT96 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.6.6/ghc-9.6.6-src.tar.xz"
  sha256 "008f7a04d89ad10baae6486c96645d7d726aaac7e1476199f6dd86c6bd9977ad"
  # We build bundled copies of libffi and GMP so GHC inherits the licenses
  license all_of: [
    "BSD-3-Clause",
    "MIT", # libffi
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"], # GMP
  ]

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(9\.6(?:\.\d+)+)\s*?</i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "8d2a22c93cc1fe70b9a7ecf62827821d30fff6d0e28c1d3bc0112c8734f96cbf"
    sha256 cellar: :any,                 arm64_sonoma:   "892f3e1bc975073cd306ac0b0522befc7456eb2308d3de05a02d399a67ef9c7a"
    sha256 cellar: :any,                 arm64_ventura:  "c4f29aff74b822d0bdb1564459168cf2cd57e0e9a1573acd8302fcff10e18609"
    sha256 cellar: :any,                 arm64_monterey: "dd173cc86b8f680233343bba11ac738f9a210a4fcb4ac45590b36bf7941018f4"
    sha256 cellar: :any,                 sonoma:         "9499925d23e2142feba32048df46024832e41e3b29d5c45ad0c31ea5d1859a8e"
    sha256 cellar: :any,                 ventura:        "ac8fc3d208583198cdfe21939ab617c221894227ec969c447f955bfc58fa8708"
    sha256 cellar: :any,                 monterey:       "ef74cf6cd94cb600ae549d4cc9572ee47ec816e7e7f4dc27aa6e3ce1e9517bcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "384d705bd320ac0a02bd5a68a5b04c734b8eae30faf8b5ff22fe5cba44007e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37e9edf08c38f365c93923036428244f9aa8fb094e44fdb2bf683172a6c81b8b"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.13" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "xz" => :build
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
        url "https://downloads.haskell.org/~ghc/9.4.8/ghc-9.4.8-aarch64-apple-darwin.tar.xz"
        sha256 "32385043d824a56983b484da5c0b3504d14b6504764731b0d48f3522ed8497ca"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.4.8/ghc-9.4.8-x86_64-apple-darwin.tar.xz"
        sha256 "fd9e21c2a9a10c60e39049e9cf1519b5b6a98a5b37e7623ba17bbd6e8dfc2036"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.4.8/ghc-9.4.8-aarch64-deb10-linux.tar.xz"
        sha256 "278e287e1ee624712b9c6d7803d1cf915ca1cce56e013b0a16215eb8dfeb1531"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.4.8/ghc-9.4.8-x86_64-ubuntu20_04-linux.tar.xz"
        sha256 "da1a1ddce5b39f6e30d8a2392753835a41ffc5ec4b914e0845270fe3a2ba4761"
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

  # Backport fix for building docs with sphinx-doc 7.
  # TODO: Remove patch if fix is backported to 9.6.
  # Ref: https://gitlab.haskell.org/ghc/ghc/-/merge_requests/10520
  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/70526f5bd8886126f49833ef20604a2c6477780a.diff"
    sha256 "54cdde1ca5d1b6fe3bbad8d0eac2b8c112ca1f346c4086d1e7361fa9510f1f44"
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
