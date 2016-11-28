class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.5.3.tar.gz"
  sha256 "1175666ec79b37fa6d3e6fda454414cecafeb537f078dda40eed96031e6fd5cc"

  bottle do
    sha256 "f69716795e4220864cad3997027c54a1713d457701c78f416151a9c858454ff0" => :sierra
    sha256 "500e16a64cc2b261d2270c326fd48ad0e1f5177b41b9e5a43f64c536ce9cba13" => :el_capitan
    sha256 "e5a81b8bd1716b847ab7bb86aa3e612526e4621a20f6f73c232af20172b08a9d" => :yosemite
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
