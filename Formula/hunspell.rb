class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.7.0.tar.gz"
  sha256 "bb27b86eb910a8285407cf3ca33b62643a02798cf2eef468c0a74f6c3ee6bc8a"
  revision 1

  bottle do
    cellar :any
    sha256 "6a668c4d0e9092b3d8f96bcef0c5cc89ad25843352e039368c549c984b2e8533" => :mojave
    sha256 "2c3e356883f40351dcb401f7622a477f6b9997545b2a4411f2eff197b77f6d16" => :high_sierra
    sha256 "a513f0f462fc874dceeeb2a57a38c2e7a477021094a08e0ee5428cf75b07e0bf" => :sierra
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

  def caveats; <<~EOS
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
