class ArpSk < Formula
  desc "ARP traffic generation tool"
  homepage "http://sid.rstack.org/arp-sk/"
  url "http://sid.rstack.org/arp-sk/files/arp-sk-0.0.16.tgz"
  sha256 "6e1c98ff5396dd2d1c95a0d8f08f85e51cf05b1ed85ea7b5bcf73c4ca5d301dd"

  bottle do
    cellar :any
    sha256 "d933c37e26f227918a6e770dc3214a76f06ca79abbf1f646a6c00447ad9933ac" => :sierra
    sha256 "5d112e8d54329bff104270b7ca27cd4884e48f8c47904bb5838a2e107c035736" => :el_capitan
    sha256 "11253608a659d16a179c9c7b25050989991a29a68c9c9b4647fe9614e191fcff" => :yosemite
    sha256 "cea3047a876b12520e9614be8cfcf09348a49522bb5c8bbb7d2c185950e4c08d" => :mavericks
  end

  depends_on "libnet"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libnet=#{Formula["libnet"].opt_prefix}"
    system "make", "install"
  end
end
