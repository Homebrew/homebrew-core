class Darkice < Formula
  desc "Live audio streamer"
  homepage "http://www.darkice.org/"
  url "https://downloads.sourceforge.net/project/darkice/darkice/1.3/darkice-1.3.tar.gz"
  sha256 "2c0d0faaa627c0273b2ce8b38775a73ef97e34ef866862a398f660ad8f6e9de6"

  bottle do
    cellar :any
    sha256 "611c7496a751c6f921f87bd3658001a200ae03b24020209a5442b6f59d61c6bc" => :el_capitan
    sha256 "79b49d0c9d3401382008f1cb0db86493947ebee6045621df5f19e9adb848619f" => :yosemite
    sha256 "fd5b2765d5d93b1c81e485a7ff6cc8176f9d77db4dcfa5e837ab5803f69162df" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "lame"
  depends_on "two-lame"
  depends_on "faac"
  depends_on "libsamplerate"
  depends_on "jack"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-lame-prefix=#{Formula["lame"].opt_prefix}",
                          "--with-faac-prefix=#{Formula["faac"].opt_prefix}",
                          "--with-twolame",
                          "--with-jack",
                          "--with-vorbis",
                          "--with-samplerate"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/darkice -h", 1)
  end
end
