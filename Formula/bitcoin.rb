class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.19.0.1/bitcoin-0.19.0.1.tar.gz"
  sha256 "7ac9f972249a0a16ed01352ca2a199a5448fe87a4ea74923404a40b4086de284"
  revision 1

  bottle do
    cellar :any
    sha256 "8234b114c86d6a439cc345a5f9c210109577a935193d713005e6a3f150492fb7" => :catalina
    sha256 "9e0c7ffed8c7b2356f57cfa87c35f918f6d6d62f8c786f82390404bee42a14d9" => :mojave
    sha256 "82fcf61607136da004c9b26d0eb7b7ffeb2cc5d39750c6899cfe2eaacad83ccf" => :high_sierra
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
