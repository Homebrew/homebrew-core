class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/6.10.1/racket-minimal-6.10.1-src-builtpkgs.tgz"
  sha256 "a6d80de7b286ee6a683b41623942c83c4d2965dee5d3b5e25f220eec4952264d"

  bottle do
    sha256 "79b4896b31b9f904be17b660ec07d1d6d17b973dfd4c4cc00efbfd8c6baa309c" => :high_sierra
    sha256 "157869883a0c58d1e4c7d158a008d6d0f8c690fcde8cd4094dd14e96c22a1708" => :sierra
    sha256 "d158e1b77c03295313f3561b25ed6aa88dd86e5f9a60f2cccb520127153b958a" => :el_capitan
    sha256 "b1555c46dab215aebe4eb1d840b37d188794ce1a2765000aa216bdb5684474aa" => :yosemite
  end

  # these two files are amended when (un)installing packages
  skip_clean "lib/racket/launchers.rktd", "lib/racket/mans.rktd"

  def install
    cd "src" do
      args = %W[
        --disable-debug
        --disable-dependency-tracking
        --enable-macprefix
        --prefix=#{prefix}
        --man=#{man}
        --sysconfdir=#{etc}
      ]

      args << "--disable-mac64" unless MacOS.prefer_64_bit?

      system "./configure", *args
      system "make"
      system "make", "install"
    end

    # configure racket's package tool (raco) to do the Right Thing
    # see: https://docs.racket-lang.org/raco/config-file.html
    inreplace etc/"racket/config.rktd" do |s|
      s.gsub!(
        /\(bin-dir\s+\.\s+"#{Regexp.quote(bin)}"\)/,
        "(bin-dir . \"#{HOMEBREW_PREFIX}/bin\")",
      )
      s.gsub!(
        /\n\)$/,
        "\n      (default-scope . \"installation\")\n)",
      )
    end
  end

  def caveats; <<-EOS.undent
    This is a minimal Racket distribution.
    If you want to build the DrRacket IDE, you may run
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
    assert_match Regexp.new(<<-EOS.undent), output
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
