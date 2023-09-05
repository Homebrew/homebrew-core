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
    url "https://downloads.haskell.org/~ghc/9.4.4/ghc-9.4.4-src.tar.xz"
    sha256 "e8cef25a6ded1531cda7a90488d0cfb6d780657d16636daa59430be030cd67e2"

    # Fix build with sphinx-doc 6+. Remove patch when available in release.
    patch do
      url "https://gitlab.haskell.org/ghc/ghc/-/commit/00dc51060881df81258ba3b3bdf447294618a4de.diff"
      sha256 "354baeb8727fbbfb6da2e88f9748acaab23bcccb5806f8f59787997753231dbb"
    end
  end

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(\d+(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f136deaa7967fd86ecece56020453a1f30d73b8a6898d0c007270c041c0b3239"
    sha256 cellar: :any,                 arm64_monterey: "c12624f0a4ee82cab1cdc390e516cdcbe9402307001b3830335389897689bd6b"
    sha256 cellar: :any,                 arm64_big_sur:  "f8f5b51f2e1504a5f18f37e762fec8f30f3bfb992422403eeb930f1302bae300"
    sha256 cellar: :any,                 ventura:        "10822b64bd093c1a19c1813cd2065aa11843f03976be92d42ca57d5f70f0d293"
    sha256 cellar: :any,                 monterey:       "8d438fe6888ca4a95e7ab2689a0549abd0815c781a37bba2f116431364296985"
    sha256 cellar: :any,                 big_sur:        "4fcdfd3cb167d33c688326a1daf7343a9a9e013b7c9a6562914f8e9694981ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bbdf64a0bcef088b7e9a89d4ff43213de8e4faf746cce595c262b3e11c63153"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.11" => :build
  depends_on "sphinx-doc" => :build
  depends_on macos: :catalina

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  # Build uses sed -r option, which is not available in Catalina shipped sed.
  on_catalina do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "gmp" => :build
  end

  # GHC 9.4.4 user manual recommend use LLVM 9 through 13
  # https://downloads.haskell.org/~ghc/9.4.4/docs/users_guide/9.4.4-notes.html
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
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.2.5/ghc-9.2.5-aarch64-deb10-linux.tar.xz"
        sha256 "29c0735ada90cdbf7e4a227dee08f18d74e33ec05d7c681e4ef95b8aa13104b3"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.2.5/ghc-9.2.5-x86_64-ubuntu20.04-linux.tar.xz"
        sha256 "be1ca5b2864880d7c3623c51f2c2ca773e380624929bf0be8cfadbdb7f4b7154"
      end
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
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.8.1.0/cabal-install-3.8.1.0-aarch64-linux-deb10.tar.xz"
        sha256 "c7fa9029f2f829432dd9dcf764e58605fbb7431db79234feb3e46684a9b37214"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.8.1.0/cabal-install-3.8.1.0-x86_64-linux-deb10.tar.xz"
        sha256 "c71a1a46fd42d235bb86be968660815c24950e5da2d1ff4640da025ab520424b"
      end
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
