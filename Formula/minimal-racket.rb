class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/8.0/racket-minimal-8.0-src-builtpkgs.tgz"
  sha256 "ef1a2dc5af4e68938a12f5fc25d1a9b3a0344e133da9c4d79132e23ac116493c"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://download.racket-lang.org/all-versions.html"
    regex(/>Version ([\d.]+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3875d84e3a363ce0fd7aec130f371196837dfbde82fc3c44d0e2f6c4bbedce45"
    sha256 cellar: :any, big_sur:       "beb2a0852ecf8684bbe1107a606949b8ca0de51af7162ed5f08c82070256f8d6"
    sha256 cellar: :any, catalina:      "be1a5ecd7b8e83ee7d16fbdc1c811a68814d38a0ffcc0584641875f6598f8e8c"
    sha256 cellar: :any, mojave:        "b258ef48248bdba52dfb728ea0c0e14704fc9f794a31fe86e870339a30ff1c8c"
  end

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
  end
end
