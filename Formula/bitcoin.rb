class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.20.1/bitcoin-0.20.1.tar.gz"
  sha256 "4bbd62fd6acfa5e9864ebf37a24a04bc2dcfe3e3222f056056288d854c53b978"
  license "MIT"
  revision 1
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    sha256 "adfe0983a4c57e70c5d084206f779d42d31b6cd4fe3e81205d81330da01c1cfe" => :catalina
    sha256 "f887ce011df22dbe1c001ee42fb6f0adddf22736fc12ea83b5d373bbd5a90e43" => :mojave
    sha256 "b6b4763357bcbadbd9439c0d39132d43306a7b9b08c61c90afbe11c6cb2b3ff1" => :high_sierra
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

  plist_options manual: "bitcoind"

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
