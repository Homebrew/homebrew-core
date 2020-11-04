class Mactelnet < Formula
  desc "Console tools for connecting to, and serving, devices using MikroTik RouterOS MAC-Telnet protocol."
  homepage "https://github.com/haakonnessjoen/MAC-Telnet"
  url "https://github.com/haakonnessjoen/MAC-Telnet/archive/v0.4.4.tar.gz"
  sha256 "2e6f041c0ff26597e6551cb564a0e41430a6ae183d31eb216493d862733f4c14"

  depends_on "gettext" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    gettext = Formula["gettext"]
    ENV.prepend_path "PATH", gettext.bin
    ENV["LDFLAGS"] = "-L#{gettext.lib}"
    ENV["CPPFLAGS"] = "-I#{gettext.include}"
    system "./autogen.sh"
    system "./configure", 
           "--disable-silent-rules",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--with-libintl-prefix=#{gettext.include}"
    system "make", "all", "install"
  end

  test do
    system "#{bin}/macping", "-v"
    system "#{bin}/mactelnet", "-v"
    system "#{bin}/mactelnetd", "-v"
  end
end
