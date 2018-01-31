class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/6.12/racket-minimal-6.12-src-builtpkgs.tgz"
  sha256 "295a422d60af2a3186a18783d033c167eeed07b936c79f404d25123a0209d683"

  bottle do
    sha256 "42adf169cca30462b9e3378d65870d95781bde69b6ecff4d69069e5c6830f750" => :high_sierra
    sha256 "1bda0b5fdeae514b9f9172d2eed3e38c7ecfdbc57926a8e756afa3197611fe0b" => :sierra
    sha256 "f274570347144e2db911d31b3512117d50198eed8c65e3c17ad2a84cb95325fe" => :el_capitan
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
