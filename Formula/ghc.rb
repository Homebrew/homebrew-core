class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.10.3/ghc-8.10.3-src.tar.xz"
  sha256 "ccdc8319549028a708d7163e2967382677b1a5a379ff94d948195b5cf46eb931"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(\d+(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 "5ed34f95506b09b1b722fbcbb2ab050854d1ade4dcc6c6b5a3220fd9f78a76f6" => :big_sur
    sha256 "1259e7d41e9ba1c89f648e412d12c70f4472f96ba969741c116c157239699d9d" => :catalina
    sha256 "eb32eeadb989c83317d8509764f8c3584df9c7f5c168d930e074f24630c94969" => :mojave
  end

  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.bz2"
    mirror "https://gmplib.org/download/gmp/gmp-6.2.1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/gmp/gmp-6.2.1.tar.bz2"
    sha256 "eae9326beb4158c386e39a356818031bd28f3124cf915f8c5b1dc4c7a36b4d7c"
  end

  # https://www.haskell.org/ghc/download_ghc_8_10_1.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      url "https://downloads.haskell.org/~ghc/8.10.3/ghc-8.10.3-x86_64-apple-darwin.tar.xz"
      sha256 "2635f35d76e44e69afdfd37cae89d211975cc20f71f784363b72003e59f22015"
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/8.10.3/ghc-8.10.3-x86_64-deb9-linux.tar.xz"
      sha256 "95e4aadea30701fe5ab84d15f757926d843ded7115e11c4cd827809ca830718d"
    end
  end

  # Fixes for macOS ARM
  # https://gitlab.haskell.org/ghc/ghc/-/merge_requests/4795
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f6c5879312437dd58087e4885a86ac536a128ea9/ghc/ghc-8.10.3.patch"
    sha256 "7aee4d6eeb37676450c84da6205e79b5ff8c9f2d4e5763f5bbf5b1c990d002b3"
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    args = []

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV["GHC"] = binary/"bin/ghc"
    end

    cpu = if Hardware::CPU.arm?
      "arm64"
    else
      Hardware.oldest_cpu
    end

    # Replace in-tree gmp with 6.2.1 which supports arm64.
    rm "libraries/integer-gmp/gmp/gmp-tarballs/gmp-6.1.2-nodoc.tar.bz2", force: true
    cp resource("gmp").cached_download, "libraries/integer-gmp/gmp/gmp-tarballs/gmp-6.2.1-nodoc.tar.bz2"

    # There is no native codegen for ARM64 yet.
    if Hardware::CPU.arm?
      args << "--enable-unregisterised"

      # The Xcode compiler is a cross compiler (ARM64/x86_64) but ghc's configure script will look for
      # the standard tool names. Go ahead and create the required names. We can not just use symbolic
      # links for gcc, nm, or ar as this confuses the command line tools.

      tmp = buildpath/"binary-cross"

      tmpbin = tmp/"bin"
      mkdir_p tmpbin

      make_contents = lambda { |command|
        <<~EOF
          #!/bin/bash
          /usr/bin/#{command} $@
        EOF
      }

      File.write(tmpbin/"#{cpu}-apple-darwin-nm", make_contents.call("nm"), { perm: 0755 })
      File.write(tmpbin/"#{cpu}-apple-darwin-ar", make_contents.call("ar"), { perm: 0755 })
      # This gcc forces ARM64 as the target. It may be invoked by an x86_64 binary (which would have
      # selected x86_64 which is not what we want.
      File.write(tmpbin/"#{cpu}-apple-darwin-gcc", make_contents.call("gcc -arch arm64"), { perm: 0755 })

      ENV.prepend_path "PATH", tmpbin

      # Basic build setup for the cross compile. This is based on the documentation for building a
      # cross compiler for targetting iOS.
      (buildpath/"mk/build.mk").write <<~EOS
        BuildFlavour = perf-cross
        HADDOCK_DOCS = NO
      EOS

      ENV["CC"] = "#{cpu}-apple-darwin-gcc"

      # Run configure as x86_64 to ensure it correctly detects the build host as x86_64. Otherwise it might
      # not cross-compile correctly.
      system "arch", "-x86_64", "./configure", "--prefix=#{tmp}", "--target=#{cpu}-apple-darwin", *args
      system "make"

      ENV.deparallelize { system "make", "install" }

      # clean up before rebuilding
      system "make", "distclean"
      rm "#{buildpath}/mk/build.mk", force: true

      ENV["CC"] = ENV.cc
      ENV["GHC"] = tmp/"bin/ghc"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
    Dir.glob(lib/"*/package.conf.d/package.cache.lock") { |f| rm f }
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
