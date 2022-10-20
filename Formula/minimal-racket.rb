class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/8.6/racket-minimal-8.6-src.tgz"
  sha256 "01d509d5ffd82920ff4bb41de84c07ecc6af9122953716ad43d84aa7b3939f48"
  license any_of: ["MIT", "Apache-2.0"]

  # File links on the download page are created using JavaScript, so we parse
  # the filename from a string in an object. We match the version from the
  # "Unix Source + built packages" option, as the `racket-minimal` archive is
  # only found on the release page for a given version (e.g., `/releases/8.0/`).
  livecheck do
    url "https://download.racket-lang.org/"
    regex(/["'][^"']*?racket(?:-minimal)?[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "0b5e925451860875bcee3426d933853df22667891deab5f58af81db44c7ec64b"
    sha256 arm64_big_sur:  "f32e1a4c7a2df5d93e160fd500df5bd9408ae3a0878469827544bb8575967127"
    sha256 monterey:       "382691a83867d3a375900057862963904dab092dbb5923a1dbfc2b0397c4d182"
    sha256 big_sur:        "6a6567b68a2213255d55fa9658823d2f7bea83bf9638d854ce3e87c12685fd49"
    sha256 catalina:       "34ac8c5df8fc1ca3ae360cb63230cbe662437ebbff43724988967876e7bc894f"
    sha256 x86_64_linux:   "5ceb281664ea1a00c477a6476757e7963e5b13db482dd57789dc474ad3ac375e"
  end

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
