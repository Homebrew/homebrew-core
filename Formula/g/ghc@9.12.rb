class GhcAT912 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.12.3/ghc-9.12.3-src.tar.xz"
  sha256 "209023906ce460e5288c9844b728a7f704868269489dc724ed097da550f6e869"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.haskell.org/ghc/"
    regex(/href=.*?download[_-]ghc[_-]v?(9[._]12[._]\d+)\.html/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "974efd21c2d102bef032deda1fd84797de3d1a4fc31c830909a3b14f0a818efc"
    sha256 cellar: :any, arm64_sequoia: "3098b4b787e74efa3fab6eac809a9cff6e60a3f636cfd4f4774ee62a510b53e4"
    sha256 cellar: :any, arm64_sonoma:  "1668903020a562e2c379bf45b9dfa24c903ec14b1250f08a099e0d37e4f673bb"
    sha256 cellar: :any, sonoma:        "fb9b19af6f902adc6f232dbbade63cac05e4e22f7c0295b5dc530e3b66b137df"
    sha256               arm64_linux:   "faceab6474296726233b4365eeef8c9b035fae6516b16a681eb6973cc07a9275"
    sha256               x86_64_linux:  "e56eddd2078e065ec3580bdbacbdc49cae97a1813c3a69b25792a7ef8b54db30"
  end

  keg_only :versioned_formula

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
      # _build/stage1/compiler/build/GHC.p_dyn_o:(.text..LsO5W_info+0x198): relocation truncated to fit:
      # R_AARCH64_JUMP26 against symbol `ghczm9zi12zi3zminplace_GHCziUtilsziPanic_showGhcException_info'
      # defined in .text.ghczm9zi12zi3zminplace_GHCziUtilsziPanic_showGhcException_info section in
      # _build/stage1/compiler/build/GHC/Utils/Panic.p_dyn_o
      depends_on "gcc@12" => :build
    end
  end

  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.10.3/ghc-9.10.3-aarch64-apple-darwin.tar.xz"
        sha256 "9f50ddd87be5cb994c719402778d6c7fdd341934fd4fbc0fcc3ecb40d49f860c"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.10.3/ghc-9.10.3-x86_64-apple-darwin.tar.xz"
        sha256 "01e4ff9530c124408db0b0f9ec7e4be35b300a6aee939c5758d1acf22d51693f"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.10.3/ghc-9.10.3-aarch64-deb10-linux.tar.xz"
        sha256 "99b85c1948e58e310f4e29cd2c8724a18c246c07e12637d8cbd591a064138236"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.10.3/ghc-9.10.3-x86_64-ubuntu20_04-linux.tar.xz"
        sha256 "b6200c32a56f26f5d2ff77c92481a47a53bb3d43cbc82b59a997aed2ad5fd937"
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

  # Apply open MR fix for regression similar to Fedora
  # https://discourse.haskell.org/t/critical-code-generation-bug-with-ghc-9-12-3/13505
  # https://gitlab.haskell.org/ghc/ghc/-/merge_requests/15264
  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/65370007e2d9f1976fbcfbb514917fb111117148.diff"
    sha256 "09e9e9313134959b90c8222213e5ab8af7d6dbd10a5c25454d7b85eced281eb8"
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
      --with-gmp-includes=#{Formula["gmp"].opt_include}
      --with-gmp-libraries=#{Formula["gmp"].opt_lib}
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

    if OS.mac?
      # https://gitlab.haskell.org/ghc/ghc/-/issues/22595#note_468423
      args << "--with-ffi-libraries=#{MacOS.sdk_path_if_needed}/usr/lib"
      args << "--with-ffi-includes=#{MacOS.sdk_path_if_needed}/usr/include/ffi"
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
