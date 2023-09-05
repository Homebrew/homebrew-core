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

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(9\.2(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f634c4de37219f963a4f275e8e635f693f47525fce8d2700261057a0d1582c9"
    sha256 cellar: :any,                 arm64_monterey: "a05983788d4e98554f5015e1565984c3f2a7d404b2d6e43ebc8614b47dde8ac5"
    sha256 cellar: :any,                 arm64_big_sur:  "8d5db82a18888f41dd5583ea9a86bf215ff4f0042aed2cf2ae7ecf55407f8ed7"
    sha256                               ventura:        "db3ab5c04a895022011458e9c2099b14cb2e054d68b5fc1318b2e9309facc94c"
    sha256                               monterey:       "9a119d3fa0a7a926fa967cfd829c7313d0c7c2ebbd3f3a42766cf9396af009e5"
    sha256                               big_sur:        "05f2c30f6d7fbbd1b66ab81bdd8a91ec1ca4a956044b978d32736acb88f7f7f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "251d11fa868f9e0af58f6e98c5c66f79034af410227175543abe0464fc834cbf"
  end

  keg_only :versioned_formula

  depends_on "python@3.11" => :build
  depends_on "sphinx-doc" => :build
  depends_on macos: :catalina

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "gmp" => :build
    on_arm do
      depends_on "numactl" => :build
    end
  end

  # GHC 9.2.5 user manual recommend use LLVM 9 through 12
  # https://downloads.haskell.org/~ghc/9.2.5/docs/html/users_guide/9.2.5-notes.html
  # and we met some unknown issue w/ LLVM 13 before https://gitlab.haskell.org/ghc/ghc/-/issues/20559
  # so conservatively use LLVM 12 here
  on_arm do
    depends_on "llvm@12"
  end

  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-aarch64-apple-darwin.tar.xz"
        sha256 "b1fcab17fe48326d2ff302d70c12bc4cf4d570dfbbce68ab57c719cfec882b05"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-x86_64-apple-darwin.tar.xz"
        sha256 "e1fe990eb987f5c4b03e0396f9c228a10da71769c8a2bc8fadbc1d3b10a0f53a"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-aarch64-deb10-linux.tar.xz"
        sha256 "cb016344c70a872738a24af60bd15d3b18749087b9905c1b3f1b1549dc01f46d"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-x86_64-ubuntu20.04-linux.tar.xz"
        sha256 "a0ff9893618d597534682123360e7c80f97441f0e49f261828416110e8348ea0"
      end
    end
  end

  # Backport fix for building docs with sphinx-doc 6.
  # TODO: Remove patch if fix is backported to 9.2.
  # Ref: https://gitlab.haskell.org/ghc/ghc/-/merge_requests/9625
  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/00dc51060881df81258ba3b3bdf447294618a4de.diff"
    sha256 "354baeb8727fbbfb6da2e88f9748acaab23bcccb5806f8f59787997753231dbb"
  end

  # Backport fix for building docs with sphinx-doc 7.
  # TODO: Remove patch if fix is backported to 9.2.
  # Ref: https://gitlab.haskell.org/ghc/ghc/-/merge_requests/10520
  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/70526f5bd8886126f49833ef20604a2c6477780a.diff"
    sha256 "54cdde1ca5d1b6fe3bbad8d0eac2b8c112ca1f346c4086d1e7361fa9510f1f44"
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = which("python3.11")
    # ARM64 Linux bootstrap binary is linked to libnuma so help it find our copy
    ENV.append_path "LD_LIBRARY_PATH", Formula["numactl"].opt_lib if OS.linux? && Hardware::CPU.arm?
    # Work around build failure: fatal error: 'ffitarget_arm64.h' file not found
    # Issue ref: https://gitlab.haskell.org/ghc/ghc/-/issues/20592
    # TODO: remove once bootstrap ghc is 9.2.3 or later.
    ENV.append_path "C_INCLUDE_PATH", "#{MacOS.sdk_path_if_needed}/usr/include/ffi" if OS.mac? && Hardware::CPU.arm?

    resource("binary").stage do
      binary = buildpath/"binary"

      binary_args = []
      if OS.linux?
        binary_args << "--with-gmp-includes=#{Formula["gmp"].opt_include}"
        binary_args << "--with-gmp-libraries=#{Formula["gmp"].opt_lib}"
      end

      system "./configure", "--prefix=#{binary}", *binary_args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-numa", "--with-intree-gmp"
    system "make"
    ENV.deparallelize { system "make", "install" }

    bash_completion.install "utils/completion/ghc.bash" => "ghc"
    (lib/"ghc-#{version}/package.conf.d/package.cache").unlink
    (lib/"ghc-#{version}/package.conf.d/package.cache.lock").unlink

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
