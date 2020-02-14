class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/7.6/racket-minimal-7.6-src-builtpkgs.tgz"
  sha256 "2e2e8e5664f1c8fe51b193d620399e6e97d14547945e331af42a5ed35847b63c"

  bottle do
    cellar :any
    sha256 "70ea8d21e62a5843b6c07cf46269ea9458001f6111b4a6c07aa5ba777ccfa87e" => :catalina
    sha256 "68d761a6679fddaf422e0fbec5897116ca409e50f12aafb3589a06586403caaa" => :mojave
    sha256 "938471c9139a10efa9c4b6f7a5d4955f7e53a1f43578662f366102086a9ed33c" => :high_sierra
  end

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

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats; <<~EOS
    This is a minimal Racket distribution.
    If you want to build the DrRacket IDE, you may run:
      raco pkg install --auto drracket

    The full Racket distribution is available as a cask:
      brew cask install racket
  EOS
  end

  test do
    output = shell_output("#{bin}/racket -e '(displayln \"Hello Homebrew\")'")
    assert_match /Hello Homebrew/, output

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
  end
end
