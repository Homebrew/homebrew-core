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
    sha256 "a64750c7861fc3b4f03cee928ed2ca238b06997df4abaeaa5281409c4b792981" => :high_sierra
    sha256 "2bad2a2582d950568996d782a88b513bad3265b2acddc7c3be00188e9282138c" => :sierra
    sha256 "76e3e8db9bcef778d8ca0e6fc89632ee2570780925b80f462a498abff3fb46ea" => :el_capitan
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
