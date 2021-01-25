class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/7.9/racket-minimal-7.9-src-builtpkgs.tgz"
  sha256 "85b201aebc1ad1ec98ac590e18052d7ef8a81af280244d00ca1c28e8543b3fe9"
  license any_of: ["MIT", "Apache-2.0"]
  revision 1

  livecheck do
    url "https://download.racket-lang.org/all-versions.html"
    regex(/>Version ([\d.]+)/i)
  end

  bottle do
    sha256 "e505c77a1703d75d214e081250cff9cbdbb13d604f8995703bd96f5a5454803d" => :big_sur
    sha256 "68ce8bdaed9890086696fe63ce655c994848e58da24040363441bdc6eaa0d9d6" => :catalina
    sha256 "4fd0070df83c2d0761bc64e31b479f776f9cee55fe51a770811748706742e528" => :mojave
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
