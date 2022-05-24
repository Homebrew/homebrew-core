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
    sha256 cellar: :any,                 arm64_monterey: "ee9b017f63375783c7bd5444482414a947700b1fd7ac059b9e52068d458d2da5"
    sha256 cellar: :any,                 arm64_big_sur:  "596b1545aab7c712d069851a2f1b5fa0937d8f429fa9a6590363b172d9d27b2e"
    sha256 cellar: :any,                 monterey:       "d5f4d654c1a377a5b88fea62d1d6eed2de14c166bbc4ac5072272ff48d9920a6"
    sha256 cellar: :any,                 big_sur:        "170c2fefda083f993451d4a6ccd6349ab6742ed3581c9610730cf88ae7083fb1"
    sha256 cellar: :any,                 catalina:       "824f7d295c28fbdb17da3015b4e4d6ca76be536f6bf81e98d5312dd7b9a095cd"
    sha256 cellar: :any,                 mojave:         "3fb3b8c1e995a9c39a56ecd91a42cc0187f3bb2541c1abb4d0b7fc922da9cb95"
    sha256 cellar: :any,                 high_sierra:    "a498fdc056b3afbb14b3138586f5dca3b0c1bae523c909c0b9383d5c5f4b02ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7905f85eaed7f1509bf78ee221c9345176ba7ba6b9e7646829db4db9aa7154f"
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
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
