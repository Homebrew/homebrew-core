class Darkice < Formula
  desc "Live audio streamer"
  homepage "https://code.google.com/p/darkice/"
  url "https://darkice.googlecode.com/files/darkice-1.2.tar.gz"
  sha256 "b3fba9be2d9c72f36b0659cd9ce0652c8f973b5c6498407f093da9a364fdb254"

  head "http://darkice.googlecode.com/svn/darkice/branches/darkice-macosx"

  bottle do
    cellar :any
    sha256 "611c7496a751c6f921f87bd3658001a200ae03b24020209a5442b6f59d61c6bc" => :el_capitan
    sha256 "79b49d0c9d3401382008f1cb0db86493947ebee6045621df5f19e9adb848619f" => :yosemite
    sha256 "fd5b2765d5d93b1c81e485a7ff6cc8176f9d77db4dcfa5e837ab5803f69162df" => :mavericks
  end

  depends_on "libvorbis"
  depends_on "lame"
  depends_on "two-lame"
  depends_on "faac"
  depends_on "jack"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lame-prefix=#{HOMEBREW_PREFIX}",
                          "--with-vorbis-prefix=#{HOMEBREW_PREFIX}",
                          "--with-twolame-prefix=#{HOMEBREW_PREFIX}",
                          "--with-faac-prefix=#{HOMEBREW_PREFIX}",
                          "--with-jack-prefix=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
