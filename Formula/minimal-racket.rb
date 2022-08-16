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
    sha256 arm64_monterey: "01f8c5b62a268cce1cca7f229a64f17209f28736ba31bf9a00ec686be5272989"
    sha256 arm64_big_sur:  "e58cc4c497c8af630449ebe4368315ff3237b3116d6c9e831a53713fd090f614"
    sha256 monterey:       "d1af5c5b6fa1e63bb17e4f53dd8aec89e92d4d1f61d9b632280c481f1722be31"
    sha256 big_sur:        "1ad575d5e1aac2d23ba88e1fd59f26e5e9b6b103ff3feb5a5223fe3040740c51"
    sha256 catalina:       "1bd094221a5bc16c5056724e35426a90136ac6e97c3a47bbd1b78d31c4aef235"
    sha256 x86_64_linux:   "b7e6a5c42265941a5590734e74a0e06071ae13b3710dbc04534ecf578181e8bd"
  end

  depends_on "openssl@1.1"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  # these two files are amended when (un)installing packages
  skip_clean "lib/racket/launchers.rktd", "lib/racket/mans.rktd"

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
  end

  def post_install
    # Run raco setup to make sure core libraries are properly compiled.
    # Sometimes the mtimes of .rkt and .zo files are messed up after a fresh
    # install, making Racket take 15s to start up because interpreting is slow.
    system "#{bin}/raco", "setup"
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
