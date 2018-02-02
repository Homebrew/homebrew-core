class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  revision 1

  stable do
    url "https://bitcoin.org/bin/bitcoin-core-0.15.1/bitcoin-0.15.1.tar.gz"
    sha256 "34de2dbe058c1f8b6464494468ebe2ff0422614203d292da1c6458d6f87342b4"

    # Boost 1.66 compat
    # Upstream commit 7 Dec 2017 "Make boost::multi_index comparators const"
    patch do
      url "https://github.com/bitcoin/bitcoin/commit/1ec0c0a01c31.patch?full_index=1"
      sha256 "a1f761fe29f78e783cb4b55f8029900f94b45d1188cb81c80f73347ee2fdc025"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "f35862353add963547629ac5ee78d8bb059db5b8f44c5b9063f5c15a84fdc887" => :high_sierra
    sha256 "2224e5dd483337e4b43c2be6e53ee7bfe96c8bb0f5b858b16534802c99a93e8d" => :sierra
    sha256 "474b22e594a48dcc9e7506641084f2f58f3329fff9afd832b1d417196ec60219" => :el_capitan
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
    pkgshare.install "share/rpcuser"
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
