class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/9.0/racket-minimal-9.0-src.tgz"
  sha256 "2c9dc012acbd980e10c60db5071e1e4597e6d12469832a80a44beab2b62ec3fe"
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
    sha256 arm64_tahoe:   "a88649b28d0714b1382626a2a3e40e924e8b03e15e4945549e69b3360c1b49e8"
    sha256 arm64_sequoia: "0701d985cd2ed98f8d4fe8698b5ade2b540bdcbdd12029f4db207cc55a42033a"
    sha256 arm64_sonoma:  "9e18d48e762da41cba33a8745c621858b412ee3bc0132afb9cd01f7f2db73f1d"
    sha256 sonoma:        "53049e21076e28824774a9a8c502bb8ec3074b25d2d2655571c3006cc3cf3f49"
    sha256 arm64_linux:   "d26bdc088dc466decc652711ef552eb4c1b605b3e2d6b2cce2c7705b2017d223"
    sha256 x86_64_linux:  "6d60e553db14780a8261be60a013daa1250e31d28cbcdb30ac0ffe8ec72608cf"
  end

  depends_on "openssl@3"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # these two files are amended when (un)installing packages
  skip_clean "lib/racket/launchers.rktd", "lib/racket/mans.rktd"

  def racket_config
    etc/"racket/config.rktd"
  end

  def install
    # configure racket's package tool (raco) to do the Right Thing
    # see: https://docs.racket-lang.org/raco/config-file.html
    inreplace "etc/config.rktd", /\)\)\n$/, ") (default-scope . \"installation\"))\n"

    # Prioritise OpenSSL 3 over OpenSSL 1.1.
    inreplace %w[libssl.rkt libcrypto.rkt].map { |file| buildpath/"collects/openssl"/file },
              '"1.1"', '"3"'

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

      ENV["LDFLAGS"] = "-rpath #{Formula["openssl@3"].opt_lib}"
      ENV["LDFLAGS"] = "-Wl,-rpath=#{Formula["openssl@3"].opt_lib}" if OS.linux?

      system "./configure", *args
      system "make"
      system "make", "install"

      # Link to the Homebrew ssl libraries, overwriting the bundled libraries
      if OS.mac?
        openssl = Formula["openssl@3"]
        racket_libdir = lib/"racket"

        %w[libssl.3.dylib libcrypto.3.dylib].each do |dylib|
          path = racket_libdir/dylib
          path.unlink if path.exist?
        end

        ln_s openssl.opt_lib/"libssl.3.dylib",    racket_libdir/"libssl.3.dylib"
        ln_s openssl.opt_lib/"libcrypto.3.dylib", racket_libdir/"libcrypto.3.dylib"
      end
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
      assert_match(%r{.*openssl@3/.*/libssl.*\.dylib}, output)
    else
      output = shell_output("LD_DEBUG=libs #{bin}/racket -e '(require openssl)' 2>&1")
      assert_match "init: #{Formula["openssl@3"].opt_lib/shared_library("libssl")}", output
    end
  end
end
