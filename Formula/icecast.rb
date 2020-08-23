class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/icecast/icecast-2.4.4.tar.gz"
  sha256 "49b5979f9f614140b6a38046154203ee28218d8fc549888596a683ad604e4d44"
  revision 1

  bottle do
    cellar :any
    sha256 "824f7d295c28fbdb17da3015b4e4d6ca76be536f6bf81e98d5312dd7b9a095cd" => :catalina
    sha256 "3fb3b8c1e995a9c39a56ecd91a42cc0187f3bb2541c1abb4d0b7fc922da9cb95" => :mojave
    sha256 "a498fdc056b3afbb14b3138586f5dca3b0c1bae523c909c0b9383d5c5f4b02ca" => :high_sierra
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
