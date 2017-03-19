class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "http://www.tcpdump.org/"
  url "http://www.tcpdump.org/release/libpcap-1.8.1.tar.gz"
  sha256 "673dbc69fdc3f5a86fb5759ab19899039a8e5e6c631749e48dcd9c6f0c83541e"
  head "git://bpf.tcpdump.org/libpcap"

  bottle do
    cellar :any
    sha256 "95a69600f13a8fae57c9d96f436a5161a0eb30f7c121dad25518039381663661" => :sierra
    sha256 "a68ac5c1c4b570fdf288c0049524c232d9122ef2c6eeae95e4f7a87f9fd6f4a4" => :el_capitan
    sha256 "e7d313172264c39a22038ac0c6fa67e1ce796406a761511b6a854a4e5a3f05dc" => :yosemite
  end

  keg_only :provided_by_osx

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-ipv6",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    assert_match /lpcap/, shell_output("#{bin}/pcap-config --libs")
  end
end
