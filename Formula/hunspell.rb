class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.6.1.tar.gz"
  sha256 "30f593733c50b794016bb03d31fd2a2071e4610c6fa4708e33edad2335102c49"

  bottle do
    cellar :any
    sha256 "c04d0b31041c404ea934706a1e349609c99f1b859b8698cb9d2bd2975add7388" => :sierra
    sha256 "1e9a1932286a3a18e4b6430b5cd24fefc8716ebaa847e7360330bfcdc317bbd3" => :el_capitan
    sha256 "79de87d8713c252d29e32e86ebf7a070994647a455a273c30779342597e86343" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext"
  depends_on "readline"

  conflicts_with "freeling", :because => "both install 'analyze' binary"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ui",
                          "--with-readline"
    system "make"
    system "make", "check"
    system "make", "install"

    pkgshare.install "tests"
  end

  def caveats; <<-EOS.undent
    Dictionary files (*.aff and *.dic) should be placed in
    ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
    provides no dictionaries for Hunspell, but you can download
    compatible dictionaries from other sources, such as
    https://wiki.openoffice.org/wiki/Dictionaries .
    EOS
  end

  test do
    system bin/"hunspell", "--help"
  end
end
