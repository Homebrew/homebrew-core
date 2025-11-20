class GhcAT910 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.10.3/ghc-9.10.3-src.tar.xz"
  sha256 "d266864b9e0b7b741abe8c9d6a790d7c01c21cf43a1419839119255878ebc59a"
  # We build bundled copies of libffi and GMP so GHC inherits the licenses
  license all_of: [
    "BSD-3-Clause",
    "MIT", # libffi
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"], # GMP
  ]

  livecheck do
    url "https://www.haskell.org/ghc/"
    regex(/href=.*?download[_-]ghc[_-]v?(9[._]10[._]\d+)\.html/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "621760fc88433b9cf482d926a5cea4072a2d0d26a1435be93e7d85c7bde4f249"
    sha256 cellar: :any,                 arm64_sequoia: "4ab20c497dd1c26e87b27787b5f392652619f72f34c1e313b60045cf8490fb86"
    sha256 cellar: :any,                 arm64_sonoma:  "8595c17b3500b2bcee8be823f5d4a0d3755f42a5637f09ba524402c2d1cd9dc5"
    sha256 cellar: :any,                 sonoma:        "752ae798ad44cd76405249c4896bc310e5a112538f310fc9cb6ac6f46d020651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd31b6bba8fb817cc6e5e0db93d34fb293d9430c6e0f65101faa233f8b586437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a28f1ff09c3587557c479a14e015ae4e8a7a1f9154cdc64691e1c0d4f9a77e1e"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.14" => :build
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
        url "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-aarch64-apple-darwin.tar.xz"
        sha256 "67be089dedbe599d911efd8f82e4f9a19225761a3872be74dfd4b5a557fb8e1a"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-x86_64-apple-darwin.tar.xz"
        sha256 "64e8cca6310443cd6de8255edcf391d937829792e701167f7e5fb234f7150078"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-aarch64-deb10-linux.tar.xz"
        sha256 "9a3776fd8dc02f95b751f0e44823d6727dea2c212857e2c5c5f6a38a034d1575"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-x86_64-ubuntu20_04-linux.tar.xz"
        sha256 "a65a4726203c606b58a7f6b714a576e7d81390158c8afa0dece3841a4c602de2"
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

    # Workaround for https://gitlab.haskell.org/ghc/ghc/-/issues/26166
    if DevelopmentTools.ld64_version == "1221.4"
      inreplace "rts/rts.cabal", /("-Wl,-undefined,dynamic_lookup)"/, "\\1,-ld_classic\""
    end

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
