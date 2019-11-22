class ArpSk < Formula
  desc "ARP traffic generation tool"
  homepage "https://web.archive.org/web/20180223202629/sid.rstack.org/arp-sk/"
  url "https://web.archive.org/web/20180223202629/sid.rstack.org/arp-sk/files/arp-sk-0.0.16.tgz"
  mirror "https://pkg.freebsd.org/ports-distfiles/arp-sk-0.0.16.tgz"
  sha256 "6e1c98ff5396dd2d1c95a0d8f08f85e51cf05b1ed85ea7b5bcf73c4ca5d301dd"

  bottle do
    cellar :any
    sha256 "bb592675e2c4cef5e98570bc5aea9f7813a3a5cd9b54235d1b44019e3eda7251" => :catalina
    sha256 "b0c8b814c565ed44ce9bf1a52f9555fa6223d64a51bece46749a71403d1988fd" => :mojave
    sha256 "db71e1610feac13246511f6c67bbf224e20b49e9a130d76dc5ca3317fe755601" => :high_sierra
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

  test do
    assert_match "arp-sk version #{version}", shell_output("#{sbin}/arp-sk -V")
  end
end
