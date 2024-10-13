class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/icecast/icecast-2.4.4.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/icecast/icecast-2.4.4.tar.gz"
  sha256 "49b5979f9f614140b6a38046154203ee28218d8fc549888596a683ad604e4d44"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/icecast/?C=M&O=D"
    regex(/href=.*?icecast[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "669009eaccd0b5a3963bc8e23516d6fc5092b75a956bc06f9a7157e0ee5c1896"
    sha256 cellar: :any,                 arm64_sonoma:   "499383218ab2e3a1b9d0de600ecfbd0ce9f792ba34333a782c072c3c5227ff2e"
    sha256 cellar: :any,                 arm64_ventura:  "f1dbdd4c3334a071987302de9a1bf78bcdda9fd4fd38599e7e8edba3d9b4dc49"
    sha256 cellar: :any,                 arm64_monterey: "1cb64c4bfce898110241fde245ba51ee8f9ce59290f9274b9e0e02b6930dce06"
    sha256 cellar: :any,                 arm64_big_sur:  "bb94499394f61cbae3fd9f68626c22b93f8647007f79ac1ee4afb8d71f6774d9"
    sha256 cellar: :any,                 sonoma:         "999d8b13ea8aa849d73452c3eea6573fea4a67cbb15a4c2778e2c50cb98c3aea"
    sha256 cellar: :any,                 ventura:        "670f11797d9920650b98eef03ce127985f07ff919f2780ba83c37c12865b93bd"
    sha256 cellar: :any,                 monterey:       "70dcce0432592b1fd218c86a3594b7d38fd664f6bfd0ddfa6ad11ca914cd216c"
    sha256 cellar: :any,                 big_sur:        "1eace833c381d2fc1989670bf8fdfa38d444177c1c855477ffc3c47b659b1340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a5ea433670e7f6a02c9ff502c6d65c56d6ea5c5e65c3eac418d3da2cf05cac2"
  end

  depends_on "pkg-config" => :build

  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
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
