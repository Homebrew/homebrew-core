class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.2.4/ghc-9.2.4-src.tar.xz"
  sha256 "15213888064a0ec4e7723d075f31b87a678ce0851773d58b44ef7aa3de996458"
  # We build bundled copies of libffi and GMP so GHC inherits the licenses
  license all_of: [
    "BSD-3-Clause",
    "MIT", # libffi
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"], # GMP
  ]

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(\d+(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "41e846a0479f930390ae2c65cf7ae0f3ea3755ff26df56822fb999722fb4932e"
    sha256 cellar: :any,                 arm64_big_sur:  "7ddd8e8dabdb5654f167aa079ef9a1290e20aa151ce3580eed24042d95d47b57"
    sha256                               monterey:       "c50034c3553a0f6099e2dfc3c7c33ca148256fedc8bc9be492cc942284bb473e"
    sha256                               big_sur:        "68f447996de80ef0aa655b9b0f5cc048503a09366b17edf77b101f9c1a38fe0b"
    sha256                               catalina:       "14f6f4c4faa2ef0e4de7b225346c3b084de3356f069ac77eed05768046c70e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea0a8011b453e37e99855a6640642303d60c6611db366cb5f2d02a7546da19b"
  end

  depends_on "python@3.10" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "gmp" => :build
  end

  # GHC 9.2.4 user manual recommend use LLVM 9 through 12
  # https://downloads.haskell.org/~ghc/9.2.4/docs/html/users_guide/9.2.4-notes.html
  # and we met some unknown issue w/ LLVM 13 before https://gitlab.haskell.org/ghc/ghc/-/issues/20559
  # so conservatively use LLVM 12 here
  on_arm do
    depends_on "llvm@12"
  end

  # https://www.haskell.org/ghc/download_ghc_9_0_2.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-x86_64-apple-darwin.tar.xz"
        sha256 "e1fe990eb987f5c4b03e0396f9c228a10da71769c8a2bc8fadbc1d3b10a0f53a"
      end
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-aarch64-apple-darwin.tar.xz"
        sha256 "b1fcab17fe48326d2ff302d70c12bc4cf4d570dfbbce68ab57c719cfec882b05"
      end
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-x86_64-ubuntu20.04-linux.tar.xz"
      sha256 "a0ff9893618d597534682123360e7c80f97441f0e49f261828416110e8348ea0"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = which("python3.10")
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
