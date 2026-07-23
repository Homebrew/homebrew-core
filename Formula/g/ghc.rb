class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.14.1/ghc-9.14.1-src.tar.xz"
  sha256 "2a83779c9af86554a3289f2787a38d6aa83d00d136aa9f920361dd693c101e77"
  license "BSD-3-Clause"
  head "https://gitlab.haskell.org/ghc/ghc.git", branch: "master"

  livecheck do
    url "https://www.haskell.org/ghc/"
    regex(/href=.*?download[_-]ghc[_-]v?(\d+(?:[._]\d+)+)\.html/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "69ab0221afe0fa73b2819d8e288a60e5ce6e00bcdf6c933c9ec4cc306cabd448"
    sha256 cellar: :any, arm64_sequoia: "a129e3570a5e3e094260dd7a8a50f479b6039144bce68b9dc7926e9a051208ec"
    sha256 cellar: :any, arm64_sonoma:  "b0a5f9c9f48feb6eb68343278546b186d360e9a0d4bcc6aa88ad261356b400a9"
    sha256 cellar: :any, sonoma:        "bae28c63fc0fc65b667bf86b1fa87554ac0c83101c4f7e0bbec51e31c2106666"
    sha256               arm64_linux:   "d6bf3ff37a93a44eafb83b7f52cf392ddf820d793a02135261e46a94edf764ff"
    sha256               x86_64_linux:  "03fbc89d0320781df97cb5745a397cda9207576b1f950342bb7c8a38197dc4c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.14" => :build
  depends_on "sphinx-doc" => :build
  depends_on "xz" => :build
  depends_on "gmp"

  uses_from_macos "m4" => :build
  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  # Build uses sed -r option, which is not available in Catalina shipped sed.
  on_catalina :or_older do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    on_arm do
      # Work around build failure with Ubuntu 22.04 toolchain (gcc/ld):
      #
      # _build/stage1/compiler/build/GHC.p_dyn_o:(.text..LsO3B_info+0x198): relocation truncated to fit:
      # R_AARCH64_JUMP26 against symbol `ghczm9zi12zi2zminplace_GHCziUtilsziPanic_showGhcException_info'
      # defined in .text.ghczm9zi12zi2zminplace_GHCziUtilsziPanic_showGhcException_info section in
      # _build/stage1/compiler/build/GHC/Utils/Panic.p_dyn_o
      depends_on "binutils" => :build
    end
  end

  # A binary of ghc is needed to bootstrap ghc
  # NOTE: GHC 9.12.3 fails https://gitlab.haskell.org/ghc/ghc/-/issues/26715
  resource "binary" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.12.2/ghc-9.12.2-aarch64-apple-darwin.tar.xz"
        sha256 "4b61b933028c63ace950236ea3382d02e51a3d9cbd1ca3f6cf4fe14c71ff436c"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.12.2/ghc-9.12.2-x86_64-apple-darwin.tar.xz"
        sha256 "e7a40e39059dd3619d7884b7382f357e79a0f4e430181b805bdd57b3be9a7300"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.12.2/ghc-9.12.2-aarch64-deb10-linux.tar.xz"
        sha256 "6048eae62ede069459398fa6f2e92ab9719e1b83e93a9014e6a410c54ed2755f"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.12.2/ghc-9.12.2-x86_64-ubuntu20_04-linux.tar.xz"
        sha256 "0cffff0a74131465bb5d1447400ea46080a10e3cd46d6c9559aa6f2a6a7537ac"
      end
    end
  end

  resource "cabal-install" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.16.1.0/cabal-install-3.16.1.0-aarch64-darwin.tar.xz"
        sha256 "e02f4561fbce72b198a3c6c81b9f211f9c7cbf40c073f8f2ee59f835dd1dd502"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.16.1.0/cabal-install-3.16.1.0-x86_64-darwin.tar.xz"
        sha256 "e09fec9aa6379d79a749d337446fa72f03f880a577d149c7b039592860bea095"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.16.1.0/cabal-install-3.16.1.0-aarch64-linux-deb10.tar.xz"
        sha256 "88363ac9f40849adf050872c14c0891eafcba5482f73537c9f2892943d135aa7"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.16.1.0/cabal-install-3.16.1.0-x86_64-linux-ubuntu20_04.tar.xz"
        sha256 "4396b9beb4e77e9a732aea35c3f12fa0993a64ea32d257add4b7b7d5b23c7894"
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
    ENV["PYTHON"] = which("python3.14")

    binary = buildpath/"binary"
    args = %W[
      --with-gmp-includes=#{formula_opt_include("gmp")}
      --with-gmp-libraries=#{formula_opt_lib("gmp")}
    ]
    resource("binary").stage do
      system "./configure", "--prefix=#{binary}", *args
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

    if OS.mac?
      # https://gitlab.haskell.org/ghc/ghc/-/issues/22595#note_468423
      args << "--with-ffi-libraries=#{MacOS.sdk_path}/usr/lib"
      args << "--with-ffi-includes=#{MacOS.sdk_path}/usr/include/ffi"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-numa", "--with-system-libffi", *args
    hadrian_args = %W[
      -j#{ENV.make_jobs}
      --prefix=#{prefix}
      --flavour=release
      --docs=no-haddocks
      --docs=no-sphinx-html
      --docs=no-sphinx-pdfs
    ]
    # Build PIC so static libraries can be used to build PIE in dependents. This is the default on ARM:
    # https://gitlab.haskell.org/ghc/ghc/-/blob/ghc-9.14.1-release/compiler/GHC/Driver/DynFlags.hs#L1275-1300
    hadrian_args << "*.*.ghc.*.opts += -fPIC -fexternal-dynamic-refs" if OS.linux? && !Hardware::CPU.arm?

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
