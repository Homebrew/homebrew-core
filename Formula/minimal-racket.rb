class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/7.8/racket-minimal-7.8-src-builtpkgs.tgz"
  sha256 "69b22b7f2054d5adb557fde42e6a3cf2f730bbc705ae7b8e5cba8c867f66c700"

  livecheck do
    url "https://download.racket-lang.org/all-versions.html"
    regex(/>Version ([\d.]+)/i)
  end

  bottle do
    cellar :any
    sha256 "7bbc4358faae0aeb94e88a87016b4ecb899b9e188c5e318afabc151eb68f4300" => :catalina
    sha256 "58f2fdad411b3e7852f1c442e2be4ccd01ed8ab3d563ef8c418de9101c989e88" => :mojave
    sha256 "a9afe8d28a6c0a67b55d9bc46d5b30ee2f169db4ce25bef25355644fd4a83163" => :high_sierra
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
