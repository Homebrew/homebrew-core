class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://github.com/bitcoin/bitcoin/archive/v0.14.2.tar.gz"
  sha256 "e0ac23f01a953fcc6290c96799deeffb32aa76ca8e216c564d20c18e75a25219"
  revision 2
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    sha256 "81e50862473315fddb4f12809ebccfcfbced729fd880f670606681d3f7e9831d" => :high_sierra
    sha256 "60b792b637213cd7887d19e5ba9d6f6919e481af870e80d39c0b0d1d13dff7f2" => :sierra
    sha256 "cfe7e0f20eea9a33084ddd04f4776e0d4c4cb05e55a735bd7f6a8b1331f4c28c" => :el_capitan
    sha256 "352daf29f60c46b0c31b313d6b40ad942f1d68fce681d5cc94dc26d83b8fcd03" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "openssl"

  needs :cxx11

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options :manual => "bitcoind"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/bitcoind</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
