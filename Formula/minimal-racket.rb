class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/6.10.1/racket-minimal-6.10.1-src-builtpkgs.tgz"
  sha256 "a6d80de7b286ee6a683b41623942c83c4d2965dee5d3b5e25f220eec4952264d"

  bottle do
    sha256 "ec279e799d2c6d37d4ba48fc47db0e87e78ea06d09c5d84e058fc3f9dc757c58" => :high_sierra
    sha256 "d84e402df127c858978ea1bcd70d02b0865f100dd3f2660f7769a79307fb7140" => :sierra
    sha256 "ffc363a76a589fbfa51b19e81cf9f9a6e7f1036074bfb9688cac1c413d175cbc" => :el_capitan
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
