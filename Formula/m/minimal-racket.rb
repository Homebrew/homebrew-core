class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/8.11.1/racket-minimal-8.11.1-src.tgz"
  sha256 "1f55fd6e1430f7239a1126cae3eb6f7855956f813230d18b2ae930280a39f3cc"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 arm64_sonoma:   "668ef627261e748cca81850ce0cfff82e95a06195bdff8a5a83b97b827bc9b0d"
    sha256 arm64_ventura:  "823097e0c7d9df7fc6a5aa462b821d241a2aa1372ec2ea88b676e95f5a64ffba"
    sha256 arm64_monterey: "3a49b8d0fdb8b4a0106070121d88eb2e4ec5dc7f9a67b82a481642954a5d96ff"
    sha256 sonoma:         "a3f0c2f3c0315725d82ebc001124cfb708c146a271da02e150bc059c8f894253"
    sha256 ventura:        "d4b8e69b02f398bcf49442459857c4d9d910293f5049de17a1c1ea336efa89b9"
    sha256 monterey:       "4227a89759a5f44192cd2660c8c108ba79de0ac0663a466fc6a8ef6911cb91c1"
    sha256 x86_64_linux:   "4ae85d638753f279823276adb714ef82b8b998a02aeca8fe3a1779ee9d2ee42f"
  end

  deprecate! date: "2023-10-24", because: "uses deprecated `openssl@1.1`"

  depends_on "openssl@1.1"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  # these two files are amended when (un)installing packages
  skip_clean "lib/racket/launchers.rktd", "lib/racket/mans.rktd"

  def racket_config
    etc/"racket/config.rktd"
  end

  def install
    # configure racket's package tool (raco) to do the Right Thing
    # see: https://docs.racket-lang.org/raco/config-file.html
    inreplace "etc/config.rktd", /\)\)\n$/, ") (default-scope . \"installation\"))\n"

    cd "src" do
      args = %W[
        --disable-debug
        --disable-dependency-tracking
        --enable-origtree=no
        --enable-macprefix
        --prefix=#{prefix}
        --mandir=#{man}
        --sysconfdir=#{etc}
        --enable-useprefix
      ]

      ENV["LDFLAGS"] = "-rpath #{Formula["openssl@1.1"].opt_lib}"
      ENV["LDFLAGS"] = "-Wl,-rpath=#{Formula["openssl@1.1"].opt_lib}" if OS.linux?

      system "./configure", *args
      system "make"
      system "make", "install"
    end

    inreplace racket_config, prefix, opt_prefix
  end

  def post_install
    # Run raco setup to make sure core libraries are properly compiled.
    # Sometimes the mtimes of .rkt and .zo files are messed up after a fresh
    # install, making Racket take 15s to start up because interpreting is slow.
    system bin/"raco", "setup"

    return unless racket_config.read.include?(HOMEBREW_CELLAR)

    ohai "Fixing up Cellar references in #{racket_config}..."
    inreplace racket_config, %r{#{Regexp.escape(HOMEBREW_CELLAR)}/minimal-racket/[^/]}o, opt_prefix
  end

  def caveats
    <<~EOS
      This is a minimal Racket distribution.
      If you want to build the DrRacket IDE, you may run:
        raco pkg install --auto drracket

      The full Racket distribution is available as a cask:
        brew install --cask racket
    EOS
  end

  test do
    output = shell_output("#{bin}/racket -e '(displayln \"Hello Homebrew\")'")
    assert_match "Hello Homebrew", output

    # show that the config file isn't malformed
    output = shell_output("'#{bin}/raco' pkg config")
    assert $CHILD_STATUS.success?
    assert_match Regexp.new(<<~EOS), output
      ^name:
        #{version}
      catalogs:
        https://download.racket-lang.org/releases/#{version}/catalog/
        https://pkgs.racket-lang.org
        https://planet-compats.racket-lang.org
      default-scope:
        installation
    EOS

    # ensure Homebrew openssl is used
    if OS.mac?
      output = shell_output("DYLD_PRINT_LIBRARIES=1 #{bin}/racket -e '(require openssl)' 2>&1")
      assert_match(%r{.*openssl@1\.1/.*/libssl.*\.dylib}, output)
    else
      output = shell_output("LD_DEBUG=libs #{bin}/racket -e '(require openssl)' 2>&1")
      assert_match "init: #{Formula["openssl@1.1"].opt_lib}/#{shared_library("libssl")}", output
    end
  end
end
