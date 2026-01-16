class GhcAT92 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.2.8/ghc-9.2.8-src.tar.xz"
  sha256 "5f13d1786bf4fd12f4b45faa37abedb5bb3f36d5e58f7da5307e8bfe88a567a1"
  # We build bundled copies of libffi and GMP so GHC inherits the licenses
  license all_of: [
    "BSD-3-Clause",
    "MIT", # libffi
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"], # GMP
  ]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "655bbab689b52ce774c6d02a43eb33ce53592b06440a088cedcee758876c50a7"
    sha256 cellar: :any,                 arm64_ventura:  "8cf37ef16647a516f9f32f35eb2919250d0042e0a7b9f8866095e295ac2fdedc"
    sha256 cellar: :any,                 arm64_monterey: "9bb8bc86992b9377bff2d36bc6b58b382a5145d5c77ee5a5e2c949b26157c439"
    sha256 cellar: :any,                 sonoma:         "a5753c516c679fb18679fa9e51ae53266629c1af6acc4a38afdc3db5bb03e2f7"
    sha256 cellar: :any,                 ventura:        "ec0c7dcb8324e4dc98ee7109504445f6ae8373f9bd582d9401ae09f0ea54c97d"
    sha256 cellar: :any,                 monterey:       "d10b5a289d3128529285ade5780d117c9e7e259eaa85b9379e5c74463a77e212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aacd44c8dff96335cc9af1c8e0e1f789fcb39c5124ac700143718bba1ed54973"
  end

  keg_only :versioned_formula

  # No longer maintained. 9.2 was removed from current releases on 2023-11-10 with 9.4.8 release.
  # Ref: https://gitlab.haskell.org/ghc/homepage/-/commit/f8e37fc84e6bc3b72e651bc778a1d6a7f2614e4b
  deprecate! date: "2024-08-15", because: :unmaintained
  disable! date: "2025-08-16", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on maximum_macos: [:sonoma, :build]
  depends_on "python@3.12" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "gmp" => :build
  end

  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.2.8/ghc-9.2.8-aarch64-apple-darwin.tar.xz"
        sha256 "34db9b19571905b08ca1e444b46490e7c19cb73a0fe778696fa6ec02ff8d3c4b"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.2.8/ghc-9.2.8-x86_64-apple-darwin.tar.xz"
        sha256 "eb78361feaf4277f627cbdc4b849849d09d175d0d878d28433719b7482db27f5"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.2.8/ghc-9.2.8-aarch64-deb10-linux.tar.xz"
        sha256 "645433359d8ad9e7b286f85ef5111db1b787ee3712c24c5dfde7c62769aa59a4"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.2.8/ghc-9.2.8-x86_64-ubuntu20.04-linux.tar.xz"
        sha256 "6e4adc184a53ca9d9dd8c11c6611d0643fdc3b76550ae769e378d9edb2bda745"
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

  # Backport fix for building docs with sphinx-doc 6.
  # Ref: https://gitlab.haskell.org/ghc/ghc/-/merge_requests/9625
  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/00dc51060881df81258ba3b3bdf447294618a4de.diff"
    sha256 "354baeb8727fbbfb6da2e88f9748acaab23bcccb5806f8f59787997753231dbb"
  end

  # Backport fix for building docs with sphinx-doc 7.
  # Ref: https://gitlab.haskell.org/ghc/ghc/-/merge_requests/10520
  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/70526f5bd8886126f49833ef20604a2c6477780a.diff"
    sha256 "54cdde1ca5d1b6fe3bbad8d0eac2b8c112ca1f346c4086d1e7361fa9510f1f44"
  end

  def install
    ENV["CC"] = ENV.cc
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

      ENV.prepend_path "PATH", binary/"bin"
    end

    resource("cabal-install").stage { (binary/"bin").install "cabal" }
    system "cabal", "v2-update"
    cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
    system "cabal", "v2-install", "alex", "happy", *cabal_args, "--installdir=#{binary}/bin"

    system "./configure", "--prefix=#{prefix}", "--disable-numa", "--with-intree-gmp"
    hadrian_args = %W[
      -j#{ENV.make_jobs}
      --prefix=#{prefix}
      --flavour=perf
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
