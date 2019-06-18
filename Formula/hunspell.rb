class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.7.0.tar.gz"
  sha256 "bb27b86eb910a8285407cf3ca33b62643a02798cf2eef468c0a74f6c3ee6bc8a"
  revision 2

  bottle do
    cellar :any
    sha256 "30927ed74597ba96c52ec0c1e9380aaaadee2adadf2e17414e1b494bfd8066b3" => :mojave
    sha256 "4ada0a39e041b9e6676b4cd68e95c6523725043088f3555d1cac1216c8f91944" => :high_sierra
    sha256 "65b1d0fc54a0de1fc7e8520aaee4dbe192a2f441757002c7b305b0fb93e3e341" => :sierra
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
