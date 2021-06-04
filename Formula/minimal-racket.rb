class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/8.1/racket-minimal-8.1-src.tgz"
  sha256 "53043e3e7f5647d296de2759aea56b56faebfe693ca08191cfb642a04db0a4e0"
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
    sha256 cellar: :any, arm64_big_sur: "6234285fe74146dfa7077605ae98569ccfa46990120216454c8484a100ce7308"
    sha256 cellar: :any, big_sur:       "a14efabedba4ab25fa1caceed9dca519a14209320973d01a98124450537eab01"
    sha256 cellar: :any, catalina:      "949d23dbde6f1be019e5ddd6e0400dea79b9a4967104308b6dec9af8a5ee2947"
    sha256 cellar: :any, mojave:        "bbfce452b9bed295d01e0efb309e8ad0016b810659a9ce9220dc699e13e6eee7"
  end

  depends_on "openssl@1.1"

  uses_from_macos "libffi"

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
      on_linux do
        ENV["LDFLAGS"] = "-Wl,-rpath=#{Formula["openssl@1.1"].opt_lib}"
      end

      system "./configure", *args
      system "make"
      system "make", "install"
    end
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
    on_macos do
      output = shell_output("DYLD_PRINT_LIBRARIES=1 #{bin}/racket -e '(require openssl)' 2>&1")
      assert_match(%r{loaded: .*openssl@1\.1/.*/libssl.*\.dylib}, output)
    end
    on_linux do
      output = shell_output("LD_DEBUG=libs #{bin}/racket -e '(require openssl)' 2>&1")
      assert_match "init: #{Formula["openssl@1.1"].opt_lib}/#{shared_library("libssl")}", output
    end
  end
end
