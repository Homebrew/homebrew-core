class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.18.0/bitcoin-0.18.0.tar.gz"
  sha256 "5e4e6890e07b620a93fdb24605dae2bb53e8435b2a93d37558e1db1913df405f"

  bottle do
    cellar :any
    sha256 "997ec756fb344e2d2fd32e6a114650be378eb1e1e771ee23521fefeb4f63b69d" => :mojave
    sha256 "4914d564d82268fb483d570e35c8133d03ba45a9f4aedb15a3ed14d1ea435557" => :high_sierra
    sha256 "f3db34cdb178af236d04afc56753235aaee7367f576080a2bd4512383717cd56" => :sierra
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
