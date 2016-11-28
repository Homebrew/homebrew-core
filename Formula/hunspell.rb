class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.5.2.tar.gz"
  sha256 "6d649981f61ab0db81027e165a98902201a68f12f9abe0d42acd57948d67f3d7"

  bottle do
    sha256 "72cbfca84b1c4fc8f2e3921dfa2313dd70aef864678ca546ff8a6cb05f094669" => :sierra
    sha256 "75fd101125513bfd3814058bdaef9473c2805a16b47e04293f5717d3a16b6a8f" => :el_capitan
    sha256 "e95451524a630a023df7582d6dcabc3528cdb043b3fcf50b606c98b52aef23dc" => :yosemite
  end

  depends_on "readline"

  conflicts_with "freeling", :because => "both install 'analyze' binary"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ui",
                          "--with-readline"
    system "make"
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
