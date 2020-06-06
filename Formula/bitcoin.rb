class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.20.0/bitcoin-0.20.0.tar.gz"
  sha256 "ec5a2358ee868d845115dc4fc3ed631ff063c57d5e0a713562d083c5c45efb28"
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    sha256 "bd973d1a270840ac5d1e2832c557117563ddeeb0a2bb80376ece027faf712d8e" => :catalina
    sha256 "edbe7d600b27737c0dfe002a6c447e1f17910746aecb2f7724af256253b60eb2" => :mojave
    sha256 "32bab1fc1ea25e3881570088aecce050c10f46f57601981db797ec66c6b94ad4" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "zeromq"

  def install
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "share/rpcauth"
  end

  plist_options :manual => "bitcoind"

  def plist
    <<~EOS
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
