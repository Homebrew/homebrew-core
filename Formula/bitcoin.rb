class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.20.1/bitcoin-0.20.1.tar.gz"
  sha256 "4bbd62fd6acfa5e9864ebf37a24a04bc2dcfe3e3222f056056288d854c53b978"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    sha256 "b517d0812bc9f4d72abd98472da90f13a441f44e2d8a8986c4be3a6bec781404" => :catalina
    sha256 "b9bd9d696d8e87ea84bb58ee4a62956fadbec61c6064f575ae88cbb24594577b" => :mojave
    sha256 "a251ff5c182db28bbfb489d5f87227e06a38257d4437b5b85f3d63c947f70363" => :high_sierra
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
