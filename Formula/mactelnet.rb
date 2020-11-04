class Mactelnet < Formula
  desc "MikroTik MAC-Telnet protocol, used in their RouterOS based products"
  homepage "https://github.com/haakonnessjoen/MAC-Telnet"
  url "https://github.com/haakonnessjoen/MAC-Telnet/archive/v0.4.4.tar.gz"
  sha256 "2e6f041c0ff26597e6551cb564a0e41430a6ae183d31eb216493d862733f4c14"
  license "GPL-2.0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure",
           "--disable-silent-rules",
           "--disable-dependency-tracking",
           "--disable-nls",
           "--without-libintl-prefix",
           "--prefix=#{prefix}"
    system "make", "all", "install"
  end

  test do
    assert_equal "MAC-Telnet", shell_output("#{bin}/macping -v")
    assert_equal "MAC-Telnet", shell_output("#{bin}/mactelnet -v")
    assert_equal "MAC-Telnet", shell_output("#{bin}/mactelnetd -v")
  end

  patch do
    url "https://github.com/haakonnessjoen/MAC-Telnet/pull/64.diff"
    sha256 "1464afa2fab04f186a2618a4783c66250c852534c9de921d30eccabd5dfd63e7"
  end
end
