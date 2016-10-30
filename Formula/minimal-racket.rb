class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/6.6/racket-minimal-6.6-src-builtpkgs.tgz"
  version "6.6"
  sha256 "f0666dbf0c7fc446f103b0c16eed508225addb09596f9c44a87b9d546422b1e9"

  bottle do
    sha256 "b90d78d65e3fb07b115a38b5d00706915863123c827601a3d58c973cb5c05f9f" => :sierra
    sha256 "939710efd3662a6dacecec89d3097eeb38b5d880abc6100e542ea804057e0de4" => :el_capitan
    sha256 "75813d0858f9d7a6f71a31e7e73e8ee0df6a0d5e794f288a948377fd44d20a14" => :yosemite
    sha256 "cc3c79837045ed6bc4a7991e5e5a8a024ea0c449a4b841f71394f3c4347cdcc0" => :mavericks
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
        "(bin-dir . \"#{HOMEBREW_PREFIX}/bin\")"
      )
      s.gsub!(
        /\n\)$/,
        "\n      (default-scope . \"installation\")\n)"
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
    assert $?.success?
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
