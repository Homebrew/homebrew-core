class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.6.0.tar.gz"
  sha256 "512e7d2ee69dad0b35ca011076405e56e0f10963a02d4859dbcc4faf53ca68e2"

  bottle do
    cellar :any
    sha256 "78d7165c49fe18af2702228176b66aacd86b938df24fd7af17c911e3ec6ed801" => :sierra
    sha256 "ca24830c14fab329a09e57be6568eb7fee6fdacaef7821efb4bc503f3a299469" => :el_capitan
    sha256 "913f5a6bd8dc3e1e4c1c711a95929534430df79aa79a72248abfb5291952b30e" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
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
    cp_r "#{pkgshare}/tests/.", testpath
    system "./test.sh"
  end
end
