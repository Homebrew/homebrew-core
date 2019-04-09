class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.7.0.tar.gz"
  sha256 "bb27b86eb910a8285407cf3ca33b62643a02798cf2eef468c0a74f6c3ee6bc8a"
  revision 1

  bottle do
    cellar :any
    sha256 "4424ad936c0d45d85afa0e0fbe610346cf0e3bddc96c88ff7efbef0f01528ffa" => :mojave
    sha256 "aa31c8817d44d1b5842837bdaeb3daa48c2cee384a683590c51577c080dc08b4" => :high_sierra
    sha256 "8e0b13ca0558d71f0edb45cc68560eec84873743b8697da739ee6119a3d9fcae" => :sierra
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
