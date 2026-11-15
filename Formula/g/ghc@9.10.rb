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
  compatibility_version 1

  livecheck do
    url "https://gitlab.haskell.org/ghc/ghc/-/wikis/GHC%20Status#all-released-ghc-versions"
    regex(/v?(9\.10(?:\.\d+)+)[._-]notes/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_golden_gate: "0b09d754f86551d012b098faa24bb62cc10dfc38803dd4cba45cf40c97e57106"
    sha256 cellar: :any, arm64_tahoe:       "f9f79ec44ee0a4187321782b5c96ee9301b91b86858b671d65dd2808bf6acffd"
    sha256 cellar: :any, arm64_sequoia:     "cbcfaea28ed8efe45ad4c097588bad4205ab6988666e8b7e062e5c36b93a090f"
    sha256 cellar: :any, arm64_linux:       "917e0464433deb2f4fc12c2e9ad29d451db8bba2e02b6ac97a499156ba484259"
    sha256 cellar: :any, x86_64_linux:      "f045a837421abe1aef66c847fdfe267edac6098c3042ec033c6bcbbe67773748"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.15" => :build
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

  # Remove RTS `-undefined dynamic_lookup` use broken by macOS 26 linkers, from 9.10.4 backports (GHC MR !16079)
  # TODO: Try removing in 9.10.4
  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/6db1e81c76b338ca18677906c9767e5f60e9ff0e.diff"
    sha256 "48f8a2bdb6af1c060f6f4d976744c9d9d1c3297c9f8f26ca39f65a18dab7f81c"
    type :backport
    resolves "https://gitlab.haskell.org/ghc/ghc/-/issues/26166"
  end

  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/d0966d3753da095dc76f2c314b2eb0dcbc828b65.diff"
    sha256 "229cf8ebf7c3228a4addf1c6dc40d79b1d4892fad4e9ca339dfc393fbc1cac2e"
    type :backport
    resolves "https://gitlab.haskell.org/ghc/ghc/-/issues/26166"
  end

  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/4ab3132f1318f36b84e7a9382bb7f26144e22388.diff"
    sha256 "cbe091d1c20473b6e1eb7e0a86674f09a336cd2fffb094656d19bd3b21aea6f4"
    type :backport
    resolves "https://gitlab.haskell.org/ghc/ghc/-/issues/26166"
  end

  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/31db96c597a6427c49de52def42883e7a3352569.diff"
    sha256 "cb5e5e7028891293927a2e2daa730dee33bfa0458f2d386cb724d0f55b22e187"
    type :backport
    resolves "https://gitlab.haskell.org/ghc/ghc/-/issues/26166"
  end

  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/2c27a1e1a39b45816323b9b0cda8585599625b63.diff"
    sha256 "399415d688a941ffcd5d22027cb3529ca2808ad9ced5e7b9a1ab9605f6bcfbe2"
    type :backport
    resolves "https://gitlab.haskell.org/ghc/ghc/-/issues/26166"
  end

  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/e1911282f61806b41fe78024b784b2d4daf4a1f8.diff"
    sha256 "60a363e1edcdf4242a8e1113b53f9545a118aa10a465c0513abfa09faa58a398"
    type :backport
    resolves "https://gitlab.haskell.org/ghc/ghc/-/issues/26166"
  end

  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/062c10a7cb68ee95ff52ae76552d6c4ff01b1d66.diff"
    sha256 "a28682b246f66900d450c877ede7b44f31b11d1a619ed692fb0ed99fea291642"
    type :backport
    resolves "https://gitlab.haskell.org/ghc/ghc/-/issues/26166"
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
    ENV["PYTHON"] = python3

    # macOS `patch` ignores the git renames in the backported diffs, so finish moving these files
    # TODO: Try removing in 9.10.4
    %w[atomic bitrev bswap clz ctz longlong mulIntMayOflo pdep popcnt word2float].each do |file|
      mv "libraries/ghc-prim/cbits/#{file}.c", "rts/prim" unless File.exist?("rts/prim/#{file}.c")
    end

    binary = buildpath/"binary"
    resource("binary").stage do
      binary_args = []
      if OS.linux?
        binary_args << "--with-gmp-includes=#{formula_opt_include("gmp")}"
        binary_args << "--with-gmp-libraries=#{formula_opt_lib("gmp")}"
      end

      system "./configure", "--prefix=#{binary}", *binary_args
      ENV.deparallelize { system "make", "install" }
    end

    ENV.prepend_path "PATH", binary/"bin"
    resource("cabal-install").stage { (binary/"bin").install "cabal" }
    system "cabal", "v2-update"

    args = []
    if OS.mac?
      # https://gitlab.haskell.org/ghc/ghc/-/issues/22595#note_468423
      args << "--with-ffi-libraries=#{MacOS.sdk_path}/usr/lib"
      args << "--with-ffi-includes=#{MacOS.sdk_path}/usr/include/ffi"
      args << "--with-system-libffi"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-numa", "--with-intree-gmp", *args
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
    (lib/"ghc-#{version}/lib/package.conf.d/package.cache").unlink
    (lib/"ghc-#{version}/lib/package.conf.d/package.cache.lock").unlink
  end

  post_install_steps do
    run "ghc-pkg", args: ["recache"], base: :bin
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
