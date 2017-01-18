class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.6.0.tar.gz"
  sha256 "512e7d2ee69dad0b35ca011076405e56e0f10963a02d4859dbcc4faf53ca68e2"
  revision 1

  bottle do
    cellar :any
    sha256 "df1df43a9275f798fca1a160aca932eeeeea252db043b16921ed2db3a70d95cc" => :sierra
    sha256 "ce02b0a9beef31b587446a07987ad4ac0cbc63c7d1144bd73721a7f53e03bd54" => :el_capitan
    sha256 "c2267b211ab4dc6ecbe997a702640beba1c9197303df77af01a61fc51f5e6ec7" => :yosemite
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
