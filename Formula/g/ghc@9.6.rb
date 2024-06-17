class GhcAT96 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.6.3/ghc-9.6.3-src.tar.xz"
  sha256 "dfcde67b4aa550a0b8a1a9bb8105835dc999fad6397cce33d72fd55d21eb77f5"
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
    sha256 cellar: :any,                 arm64_sonoma:   "4090536366174048455a6cbc22dfcfde6bd651a4514d1c5db2616dad6fa856b2"
    sha256 cellar: :any,                 arm64_ventura:  "4cb14f641c0528875106cd2da6467d16bb4a2f235668713ff53e65d59936b334"
    sha256 cellar: :any,                 arm64_monterey: "4780ec3532aaa127f5af54da4b80852b185403cd3df62d6d862679836228716a"
    sha256 cellar: :any,                 sonoma:         "217e396300b2f4409280a60cf5cb0f807474ba60cc9fa7f94b2b30ebbdf5a170"
    sha256 cellar: :any,                 ventura:        "c120f617c6e869bf0f3665445da22c7c2ad5e5b87dc2845411d97519bdb4ba24"
    sha256 cellar: :any,                 monterey:       "6073bbdf81da5055ec819eeb19fd6c9c3a589755e63db5b2e1d3240ddcb8e9a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5a089e4157c5f5230050c272606661a902840f66bb8ebbb963548b6ca9e23e3"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.12" => :build
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
        url "https://downloads.haskell.org/~ghc/9.4.7/ghc-9.4.7-aarch64-apple-darwin.tar.xz"
        sha256 "5d85f9836d72d45634039218ed52e9faa0ed00c0db056f3d1162b4c2b3838e38"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.4.7/ghc-9.4.7-x86_64-apple-darwin.tar.xz"
        sha256 "2c874dc685cb72b0c4d6f226b795051705a923c25080eeba05d546350474cb1e"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.4.7/ghc-9.4.7-aarch64-deb10-linux.tar.xz"
        sha256 "05896fc4bc52c117d281eac9c621c6c3a0b14f9f9eed5e42cce5e1c4485c7623"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.4.7/ghc-9.4.7-x86_64-ubuntu20_04-linux.tar.xz"
        sha256 "f1c5c4f9257d06acf9da655f0491cf897ed05dece95f6266fdd880998125467a"
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

  # Backport fix for building docs with sphinx-doc 7.
  # TODO: Remove patch if fix is backported to 9.6.
  # Ref: https://gitlab.haskell.org/ghc/ghc/-/merge_requests/10520
  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/70526f5bd8886126f49833ef20604a2c6477780a.diff"
    sha256 "54cdde1ca5d1b6fe3bbad8d0eac2b8c112ca1f346c4086d1e7361fa9510f1f44"
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
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
