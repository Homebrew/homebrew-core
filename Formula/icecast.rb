class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/icecast/icecast-2.4.4.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/icecast/icecast-2.4.4.tar.gz"
  sha256 "49b5979f9f614140b6a38046154203ee28218d8fc549888596a683ad604e4d44"
  revision 1

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/icecast/?C=M&O=D"
    regex(/href=.*?icecast[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "4eb9c107f4b16bdbc9efff532f00aad8f227405ea8000207b7b88cb71e32b8fd"
    sha256 cellar: :any,                 arm64_monterey: "af7fd9e799b9d6ce1878595e28e21f8faf3c37dd3932fde612526d6e6d49ebe2"
    sha256 cellar: :any,                 arm64_big_sur:  "b7a6e3a7523fef943c038fe13bbacae2a3a68c7a340ab9eb3e7f3eff9ecb3886"
    sha256 cellar: :any,                 ventura:        "d342130f38d0e24785ef49eaf4baf9f73b16340f38852ad2cd96f469c00db566"
    sha256 cellar: :any,                 monterey:       "20fa587a4c56601c9e6c20376eb32b6bb699003bb134dd078d2aaa55ffbbd88c"
    sha256 cellar: :any,                 big_sur:        "b196a319590c996ce6a95597922df8b20bbf57ccf1accee46f04d0958c89d977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "118242d50e7fe10915271d3d852c9f0a02f8ccbe4016c0d17e27f04556985666"
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]
    # HACK: Avoid linking brewed `curl` as side effect of `using: :homebrew_curl`
    args << "--with-curl-config=/usr/bin/curl-config" if OS.mac?

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  def post_install
    (var/"log/icecast").mkpath
    touch var/"log/icecast/access.log"
    touch var/"log/icecast/error.log"
  end

  test do
    port = free_port

    cp etc/"icecast.xml", testpath/"icecast.xml"
    inreplace testpath/"icecast.xml", "<port>8000</port>", "<port>#{port}</port>"

    pid = fork do
      exec "icecast", "-c", testpath/"icecast.xml", "2>", "/dev/null"
    end
    sleep 3

    begin
      assert_match "icestats", shell_output("curl localhost:#{port}/status-json.xsl")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
