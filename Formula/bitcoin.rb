class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.19.0.1/bitcoin-0.19.0.1.tar.gz"
  sha256 "7ac9f972249a0a16ed01352ca2a199a5448fe87a4ea74923404a40b4086de284"
  revision 1

  bottle do
    cellar :any
    sha256 "7af2f9d403cd5ccaa285f6c284aa37112a8a1060c93a656c750a4fdcab45abcc" => :catalina
    sha256 "8d05c31f6a2e15aa6bb23f69938adc50df45a10d6277ed07467e849b91db1bd4" => :mojave
    sha256 "4c9d743d4186adcd4660ebb2456f5dd5586a09f461d302ba09756be5510ceba9" => :high_sierra
  end

  head do
    url "https://github.com/bitcoin/bitcoin.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "openssl@1.1"
  depends_on "zeromq"

  # Fix for Boost 1.72
  # https://github.com/bitcoin/bitcoin/pull/17654
  patch do
    url "https://github.com/bitcoin/bitcoin/commit/ddecb671.diff?full_index=1"
    sha256 "79e52316dbcb1ad06caeea58363ab2365983522d23c02f3102c88138ec9b18b0"
  end

  def install
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      ENV.delete("SDKROOT")
    end

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "share/rpcauth"
  end

  plist_options :manual => "bitcoind"

  def plist; <<~EOS
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
