class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/8.14/racket-minimal-8.14-src.tgz"
  sha256 "fc1867c88c38410d9a30a5bc143265b1a9525b7a532ea3fbe025c9d79b5de6ca"
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
    sha256 arm64_sequoia: "f9af0b81bc5cecd17d516d9e57aa747f278d7ddd91a691968c0801b531ce79d9"
    sha256 arm64_sonoma:  "bcbfcd5e2f2166dad1a30e2b7dfb8b35b2dd4e5bbd29fff6162582229395c518"
    sha256 arm64_ventura: "8697c72d6a75610af0497585c859621a93ee8c30032654ce1db9eb61479eda7a"
    sha256 sonoma:        "013177783128e5c5da3fc26e5079d255aeac8530f6f160c32e10e08f5a98adae"
    sha256 ventura:       "1f2a47ce0e1c27a7ce9d84498f5b2830708c8d9b577d41b3c1bc53865235e4e6"
    sha256 x86_64_linux:  "db0f9c99f911a5b16c8f57f2eb92e76a621c0ad1eaff3cf55d784b006475bf23"
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
