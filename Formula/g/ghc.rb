class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  # We build bundled copies of libffi and GMP so GHC inherits the licenses
  license all_of: [
    "BSD-3-Clause",
    "MIT", # libffi
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"], # GMP
  ]
  head "https://gitlab.haskell.org/ghc/ghc.git", branch: "master"

  stable do
    url "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-src.tar.xz"
    sha256 "e2fb7a7dd7461237d22e8365a83edd9e1a77d2e15d045f3945396845a87781c9"

    # Backport fix for autoconf 2.72.
    patch do
      url "https://gitlab.haskell.org/ghc/ghc/-/commit/c9731d6d3cad01fccb88c99c4f26070a44680389.diff"
      sha256 "f7e921f7096c97bd4e63ac488186a132eb0cc508d04f0c5a99e9ded51bf16b25"
    end
  end

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(\d+(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3f307c1dd3a7f6978f61559e50e5ed8a5f80aa9b6c177bc6fc380e8a7750e67b"
    sha256 cellar: :any,                 arm64_ventura:  "a5866a3dd17f1625dd6c5614bf4009b9b9fa3f250de20c9b1537bcb4243c5a07"
    sha256 cellar: :any,                 arm64_monterey: "c232ee8df13d646fb1620366fb619a578c9c8d78226a1aa53911a68f417f6a38"
    sha256 cellar: :any,                 sonoma:         "fc0419aa104bf0ceade5a88e43197b5772471111d56ac72c5bab170d16297700"
    sha256 cellar: :any,                 ventura:        "85d49206c4493c98aed170ed714b8cdbca8422941cd866ecb8382bd1ffbc136a"
    sha256 cellar: :any,                 monterey:       "5da681c7ed9784fa0b272fddfa5e4386292819cd10fcbe3d4d3240b4bffc047c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45126aef7e10a910368e2ef37bb37795c9951a3551fd91d414a7e452498deac9"
  end

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
        url "https://downloads.haskell.org/~ghc/9.6.3/ghc-9.6.3-aarch64-apple-darwin.tar.xz"
        sha256 "e1cdf458926b2eaf52d2a8287d99a965040ff9051171f5c3b7467049cf0eb213"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.6.3/ghc-9.6.3-x86_64-apple-darwin.tar.xz"
        sha256 "dde46118ab8388fb1066312c097123e93b1dcf6ae366e3370f88ea456382c9db"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.6.3/ghc-9.6.3-aarch64-deb10-linux.tar.xz"
        sha256 "03c389859319f09452081310fc13af7525063ea8930830ef76be2a14b312271e"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.6.3/ghc-9.6.3-x86_64-ubuntu20_04-linux.tar.xz"
        sha256 "d2018768b53ab2c9ab4d543d1e8d7c2b1fb78707b70c74c96ff1733e82f22b80"
      end
    end
  end

  resource "cabal-install" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-aarch64-darwin.tar.xz"
        sha256 "d2bd336d7397cf4b76f3bb0d80dea24ca0fa047903e39c8305b136e855269d7b"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-x86_64-darwin.tar.xz"
        sha256 "cd64f2a8f476d0f320945105303c982448ca1379ff54b8625b79fb982b551d90"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-aarch64-linux-deb10.tar.xz"
        sha256 "004ed4a7ca890fadee23f58f9cb606c066236a43e16b34be2532b177b231b06d"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-x86_64-linux-ubuntu20_04.tar.xz"
        sha256 "c2a8048caa3dbfe021d0212804f7f2faad4df1154f1ff52bd2f3c68c1d445fe1"
      end
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = which("python3.12")
    # Work around `ENV["CC"]` no longer being used unless set to absolute path.
    # Caused by https://gitlab.haskell.org/ghc/ghc/-/commit/6be2c5a7e9187fc14d51e1ec32ca235143bb0d8b
    # Issue ref: https://gitlab.haskell.org/ghc/ghc/-/issues/22175
    # TODO: remove once upstream issue is fixed
    ENV["ac_cv_path_CC"] = ENV.cc

    binary = buildpath/"binary"
    resource("binary").stage do
      binary_args = []
      if OS.linux?
        binary_args << "--with-gmp-includes=#{Formula["gmp"].opt_include}"
        binary_args << "--with-gmp-libraries=#{Formula["gmp"].opt_lib}"
      end

      system "./configure", "--prefix=#{binary}", *binary_args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
      # Build uses sed -r option, which is not available in Catalina shipped sed.
      ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac? && MacOS.version <= :catalina
    end

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
    # Work around linkage error due to RPATH in ghc-iserv-dyn-ghc
    # Issue ref: https://gitlab.haskell.org/ghc/ghc/-/issues/22557
    unless build.head?
      os = OS.mac? ? "osx" : OS.kernel_name.downcase
      cpu = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch.to_s
      extra_rpath = rpath(source: lib/"ghc-#{version}/bin",
                          target: lib/"ghc-#{version}/lib/#{cpu}-#{os}-ghc-#{version}")
      hadrian_args << "*.iserv.ghc.link.opts += -optl-Wl,-rpath,#{extra_rpath}"
    end
    # Let hadrian handle its own parallelization
    ENV.deparallelize { system "hadrian/build", "install", *hadrian_args }

    bash_completion.install "utils/completion/ghc.bash" => "ghc"
    ghc_libdir = build.head? ? lib.glob("ghc-*").first : lib/"ghc-#{version}"
    (ghc_libdir/"lib/package.conf.d/package.cache").unlink
    (ghc_libdir/"lib/package.conf.d/package.cache.lock").unlink
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
