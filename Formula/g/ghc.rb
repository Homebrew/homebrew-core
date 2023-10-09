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
    url "https://downloads.haskell.org/~ghc/9.6.2/ghc-9.6.2-src.tar.xz"
    sha256 "1b510c5f8753c3ba24851702c6c9da7d81dc5e47fe3ecb7af39c7c2613abf170"

    # Backport fix for building docs with sphinx-doc 7.
    # TODO: Remove patch if fix is backported to 9.2.
    # Ref: https://gitlab.haskell.org/ghc/ghc/-/merge_requests/10520
    patch do
      url "https://gitlab.haskell.org/ghc/ghc/-/commit/70526f5bd8886126f49833ef20604a2c6477780a.diff"
      sha256 "54cdde1ca5d1b6fe3bbad8d0eac2b8c112ca1f346c4086d1e7361fa9510f1f44"
    end
  end

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(\d+(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e89a18c220bd992dabde05f685ae5ca1f412856c9421c2c066398f24b3e8dec9"
    sha256 cellar: :any,                 arm64_ventura:  "5f0ceea5ef3b297c1242c54c47e11db5025c40178c2eac1a9206c831d22c78c9"
    sha256 cellar: :any,                 arm64_monterey: "a115b3694d2c598c92b13493544a74586b0ce675bc04b9daba463d9c135c6b69"
    sha256 cellar: :any,                 sonoma:         "0e8fd8f7919330c3fcf09a703882807eeec4032bcc6da1b48d0647eedfe5a0c4"
    sha256 cellar: :any,                 ventura:        "68210c08680ba4f73f7aedaea255b158c9cf29b7345542f3b86c83744b13c1eb"
    sha256 cellar: :any,                 monterey:       "e7b817231ed43f51fd315775c5773048d2b71cce7d6b82b374fc8ea4bb60998e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a88a982eb858d5f38734392ca755aaa484494aad6101281174ece9e201ca6a0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.11" => :build
  depends_on "sphinx-doc" => :build
  depends_on "xz" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

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
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.1.0/cabal-install-3.10.1.0-aarch64-darwin.tar.xz"
        sha256 "fdabdc4dca42688a97f2b837165af42fcfd4c111d42ddb0d4df7bbebd5c8750e"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.1.0/cabal-install-3.10.1.0-x86_64-darwin.tar.xz"
        sha256 "893a316bd634cbcd08861306efdee86f66ec634f9562a8c59dc616f7e2e14ffa"
      end
    end
    on_linux do
      url "https://downloads.haskell.org/~cabal/cabal-install-3.10.1.0/cabal-install-3.10.1.0-x86_64-linux-ubuntu20_04.tar.xz"
      sha256 "b0752c4c5e53eec56af23a1e7cd5a18b5fc62dd18988962aa0aa8748a22af52d"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = which("python3.11")
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
      ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if MacOS.version == :catalina
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
