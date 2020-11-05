class Mactelnet < Formula
  desc "MikroTik MAC-Telnet protocol, used in their RouterOS based products"
  homepage "https://github.com/haakonnessjoen/MAC-Telnet"
  url "https://github.com/haakonnessjoen/MAC-Telnet/archive/v0.4.4.tar.gz"
  sha256 "2e6f041c0ff26597e6551cb564a0e41430a6ae183d31eb216493d862733f4c14"
  license "GPL-2.0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  patch do
    url "https://github.com/haakonnessjoen/MAC-Telnet/commit/64efc157945fd93134449fb0d75288170842cbe8.patch?full_index=1"
    sha256 "6cd8bda911c7f1b1dc99adb5b6d66dcc2d2c0e7490c1ad898235dfd81bc70abe"
  end

  patch do
    url "https://github.com/haakonnessjoen/MAC-Telnet/commit/321ba89d046308c7bc956de203f107a12792f64d.patch?full_index=1"
    sha256 "a4569cd4e82a37d0e76c95074eb2b77ae82cf767a5d23d3a96f23427906aa228"
  end

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
end
