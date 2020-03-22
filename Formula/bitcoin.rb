class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.19.1/bitcoin-0.19.1.tar.gz"
  sha256 "f2591d555b8e8c2e1bd780e40d53a91e165d8b3c7e0391ae2d24a0c0f23a7cc0"

  bottle do
    cellar :any
    sha256 "e1902a3ca29ed8ad78379f8f8bc321336839b2a58162262849482901b275c5b7" => :catalina
    sha256 "1465bd8b7f32cfed0fdf696b0b49d531fc5bbe6b755b4842479c932baff97930" => :mojave
    sha256 "c8b49b2a830d79dd64730b6ff82067f2712f422057bb6756e5849581560eb876" => :high_sierra
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

  def install
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "./autogen.sh" if build.head?
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
