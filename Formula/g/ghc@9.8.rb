class GhcAT98 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.8.4/ghc-9.8.4-src.tar.xz"
  sha256 "17e8188f3c8a5c2f73fb4e35d01032e8dc258835ec876d52c8ad8ee3d24b2fc5"
  # We build bundled copies of libffi and GMP so GHC inherits the licenses
  license all_of: [
    "BSD-3-Clause",
    "MIT", # libffi
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"], # GMP
  ]

  livecheck do
    url "https://gitlab.haskell.org/ghc/ghc/-/wikis/GHC%20Status#all-released-ghc-versions"
    regex(/v?(9\.8(?:\.\d+)+)[._-]notes/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e87df3e2191a0bc9b59349222a521ef3d5839f2d329eda02077d47190f670f1"
    sha256 cellar: :any,                 arm64_sequoia: "77cf644f73bd7942775f30101b61c4425c9c3d45d8ba5c3af80e6b3c5e689f4a"
    sha256 cellar: :any,                 arm64_sonoma:  "1a10ae542525f70b3c308122da20a293f26a80ddb9e60df6d4ce3dc7aa1fa0f7"
    sha256 cellar: :any,                 arm64_ventura: "2a294afb0daafc46a01f07b28ce8b12c99e7cf012636db9e1ec2cad571cb7159"
    sha256 cellar: :any,                 sonoma:        "1ef721a935beec2ae8dee98c5114688006fba633e326b8fb539c0c579aea6692"
    sha256 cellar: :any,                 ventura:       "cb6edb4b9148cd65d58e0eb460717156a508e30746a9041913fa9d723b7e4021"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee9cead55676496b271a1471cc969c331f7d890fa17c5719ff919dd1c8f51c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062b63708890292cd293ab0e7b836807cf7b37751e6f5717490921b777acb517"
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
    ENV["PYTHON"] = which("python3.14")

    # Workaround for https://gitlab.haskell.org/ghc/ghc/-/issues/26166
    if DevelopmentTools.ld64_version == "1221.4"
      inreplace "rts/rts.cabal.in", /("-Wl,-undefined,dynamic_lookup)"/, "\\1,-ld_classic\""
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
