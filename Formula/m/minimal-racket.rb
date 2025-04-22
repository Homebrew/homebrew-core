class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/8.16/racket-minimal-8.16-src.tgz"
  sha256 "4e727db75574ab11d6bec7af5e5d72a084fa7f662e200c35d5bc200772f5ce96"
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
    sha256 arm64_sequoia: "1c13971c4685d61b4a998d18f53b1285044604be397e03b84291e68e08547a6f"
    sha256 arm64_sonoma:  "12f2f918bf8ae7c880fa3e96d3c5de0fe872b5d087b54615e6d16c4e176e0d84"
    sha256 arm64_ventura: "1913e3527eeeb09b2a601a406a64500c3d0d31d3d66c1733f542e6f6d2f33a9f"
    sha256 sonoma:        "a318548748b2c74fe576f00623b8c63eb999faf4cbc36aadaea23485ea9e09a7"
    sha256 ventura:       "55e3661eb9f4c4544a4595ba98dc4f6ecb39ac725c04562ee8126855ef5e09ff"
    sha256 arm64_linux:   "be6ee4a1db72e1a0a33e4aa6562f907f30740f0d529b42f9d15e1be187ce7e54"
    sha256 x86_64_linux:  "907ef000531b5bac63feadcae9ca4e6518709384e088c6f33139bb43b1867575"
  end

  depends_on "openssl@3"

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
