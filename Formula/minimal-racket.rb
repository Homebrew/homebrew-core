class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/7.0/racket-minimal-7.0-src-builtpkgs.tgz"
  sha256 "dab411d76ed5b1accbba9c7e934737e0a984099542c6df57cf55e9c96247d0fe"

  bottle do
    sha256 "578ffb5e2f423a044f8f7f1917bdf23436f2731df83b11f34081e60fb1ff9f0c" => :mojave
    sha256 "03db9d43fa5d5cdb784007de7495531379973cff9a6d9dbae14af8667a67b30c" => :high_sierra
    sha256 "56eb6622bcc55384d4dd50e560b00acd4a5c479968e644795fd8fb85fa8c8d01" => :sierra
    sha256 "5bce9d80b25c2cf1d709ea564fc94f289845a2dc0e6a3905612d6f272f2a165f" => :el_capitan
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

  def caveats; <<~EOS
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
