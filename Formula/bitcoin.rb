class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.17.1/bitcoin-0.17.1.tar.gz"
  sha256 "3e564fb5cf832f39e930e19c83ea53e09cfe6f93a663294ed83a32e194bda42a"
  revision 1

  bottle do
    cellar :any
    sha256 "db844809efff3e95d080a2ff5daece1307f575644de2fc04589041ddf82bc7f6" => :mojave
    sha256 "0c0aeea4647867639494fe703ac4b21419548c3a9e3efb8d27a035ee4d84071e" => :high_sierra
    sha256 "349f5c915ca2d363befa0d5c6fbbcc6b97757bb1d29c2ce9b3ab939d2e4326da" => :sierra
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
  depends_on "openssl"
  depends_on "zeromq"

  needs :cxx11

  def install
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? &&
       MacOS::Xcode.version >= "8.0"
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
