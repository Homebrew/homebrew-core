class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.4.3/ghc-9.4.3-src.tar.xz"
  sha256 "eaf63949536ede50ee39179f2299d5094eb9152d87cc6fb2175006bc98e8905a"
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
    sha256 cellar: :any,                 arm64_monterey: "e561c3b8ae12ab2a7b94a09b3c3b5895b9684a08eb136d484c9924e6d1f1efa2"
    sha256 cellar: :any,                 arm64_big_sur:  "4673cdb3ffc12715c76c1531c6b67f2bb76c2b0f46857d89037971fcfccdfd69"
    sha256                               ventura:        "44380e395bfd793fe5bd194b7ad5297f367bd8a9a33e0c663f7670c533b94a52"
    sha256                               monterey:       "9958adc0fe9861b032206d1d08f1b3ffc2d1db10ac3ca75c470ef1db03cc54c0"
    sha256                               big_sur:        "2aaeb6627b6266759a3812ce9a1ffdbf82067dc1ade27736f0ec74706bc5870e"
    sha256                               catalina:       "e32a672210b61c79a293e64040a6135f78617de5ee8d1f9e0ea83ee8fd11015f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66de55e420c039535422aed4c7803285faedf5292dd2385f6b7d7bcc5d899d94"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.11" => :build
  depends_on "sphinx-doc" => :build
  depends_on macos: :catalina

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "gmp" => :build
  end

  # GHC 9.4.3 user manual recommend use LLVM 9 through 13
  # https://downloads.haskell.org/~ghc/9.4.3/docs/users_guide/9.4.3-notes.html
  # and we met some unknown issue w/ LLVM 13 before https://gitlab.haskell.org/ghc/ghc/-/issues/20559
  # so conservatively use LLVM 12 here
  on_arm do
    depends_on "llvm@12"
  end

  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.2.5/ghc-9.2.5-aarch64-apple-darwin.tar.xz"
        sha256 "b060ad093e0d86573e01b3d1fd622d4892f8d8925cbb7d75a67a01d2a4f27f18"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.2.5/ghc-9.2.5-x86_64-apple-darwin.tar.xz"
        sha256 "6c46f5003f29d09802d572a7c5fabf6c1f91714a474967a5415b15df77fdcd90"
      end
    end
    on_linux do
      url "https://downloads.haskell.org/~ghc/9.2.5/ghc-9.2.5-x86_64-ubuntu20.04-linux.tar.xz"
      sha256 "be1ca5b2864880d7c3623c51f2c2ca773e380624929bf0be8cfadbdb7f4b7154"
    end
  end

  resource "cabal-install" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.8.1.0/cabal-install-3.8.1.0-aarch64-darwin.tar.xz"
        sha256 "f75b129c19cf3aa88cf9885cbf5da6d16f9972c7f770c528ca765b9f0563ada3"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.8.1.0/cabal-install-3.8.1.0-x86_64-darwin.tar.xz"
        sha256 "f5ff69127b0e596b0d7895a2b0b383543aa92ae46d9b1b28f2868d2a97ed0de9"
      end
    end
    on_linux do
      url "https://downloads.haskell.org/~cabal/cabal-install-3.8.1.0/cabal-install-3.8.1.0-x86_64-linux-deb10.tar.xz"
      sha256 "c71a1a46fd42d235bb86be968660815c24950e5da2d1ff4640da025ab520424b"
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
    end

    resource("cabal-install").stage { (binary/"bin").install "cabal" }
    system "cabal", "v2-update"
    if build.head?
      cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
      system "cabal", "v2-install", "alex", "happy", *cabal_args, "--installdir=#{binary}/bin"
      system "./boot"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-numa", "--with-intree-gmp"
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

    bin.env_script_all_files libexec, PATH: "${PATH}:#{Formula["llvm@12"].opt_bin}" if Hardware::CPU.arm?
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
