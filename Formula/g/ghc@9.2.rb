class GhcAT92 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.2.7/ghc-9.2.7-src.tar.xz"
  sha256 "a253567a17b734a4c0dd0ffa296d33c2a5b5a54a77df988806a2a1e1ca7e88b8"
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
    sha256 cellar: :any,                 arm64_ventura:  "0af1db969ed72a0f25561a2054d5c67a8a15b247234a08a0fa8159e77d50a19b"
    sha256 cellar: :any,                 arm64_monterey: "550b2f48a19740c84a7d147938084f97300a75529bd86d6d7c7cf504f7a6d2a1"
    sha256 cellar: :any,                 arm64_big_sur:  "51e4d62fd94a3727f0e7215f23d6ee4b9b5200c749ec444847328cd9220e366a"
    sha256                               ventura:        "41d9d7f56277c1c754c0e886366075d3fbba7a697a01930a92ed5e047faa9a84"
    sha256                               monterey:       "b7256998d71a45df0753a2fd7f464fe7ae6e1801085136d6af6c1e2042ec4309"
    sha256                               big_sur:        "7b2ca4c7eebaea706e55a6442eb40569d784f301e5446d7adc606013808876f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e73d344e6e4e686a13fdbd2cdbb22658b74aec42e0eb42c27412c5fc28de8f7e"
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

  # Fix build with sphinx-doc 6+ using open upstream MR.
  # TODO: Update commit when upstream MR is merged.
  # TODO: Remove patch if fix is backported to 9.2.
  # Ref: https://gitlab.haskell.org/ghc/ghc/-/merge_requests/9625
  patch do
    url "https://gitlab.haskell.org/ghc/ghc/-/commit/10e94a556b4f90769b7fd718b9790d58ae566600.diff"
    sha256 "354baeb8727fbbfb6da2e88f9748acaab23bcccb5806f8f59787997753231dbb"
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
