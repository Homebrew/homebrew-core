class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "https://icecast.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/icecast/icecast-2.4.4.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/icecast/icecast-2.4.4.tar.gz"
  sha256 "49b5979f9f614140b6a38046154203ee28218d8fc549888596a683ad604e4d44"
  license "GPL-2.0-only"
  revision 3

  # Upstream has used a 999 patch version to presumably indicate an unstable
  # version. We've seen this in other projects that use a 90+ patch to indicate
  # unstable versions, so we use a related pattern in the regex to avoid those
  # potential versions as well.
  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/icecast/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)icecast[._-]v?(\d+\.\d+(?:\.(?:\d|[1-8]\d+)(?:\.\d+)*)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4529a76a5b5c21b5214c556fb5d351df235150634aebdc35da57de778a9822b6"
    sha256 cellar: :any,                 arm64_sequoia: "1db70e82f5d1940e4a47b197d1035fbb10e59424e93228dfce20e33b39dde16b"
    sha256 cellar: :any,                 arm64_sonoma:  "ce404b7e770f3dc7ef5cfed40e2b6752f9104b0ffc952e6ee847ab76e7abb29c"
    sha256 cellar: :any,                 sonoma:        "47cb310dc10fb7169072e22dd97397e7918f6ff3c7bb561b632f6f314b3374dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "194c895b07fadfaee954a587d5129eba86923bf832c1a017f68ec87a43d82588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1712b36a4b604ada1227303bdbcf679e4c5ab392af44cbce8f75f7b6af6b3ec0"
  end

  depends_on "pkgconf" => :build

  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    args = %W[
      --disable-silent-rules
      --without-speex
      --without-theora
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]
    system "./configure", *args, *std_configure_args
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

    pid = spawn "icecast", "-c", testpath/"icecast.xml", err: "/dev/null"
    sleep 3

    begin
      assert_match "icestats", shell_output("curl localhost:#{port}/status-json.xsl")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
