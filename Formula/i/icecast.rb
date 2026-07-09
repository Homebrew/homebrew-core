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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "5fff6c2e934272b3b0dc2075d9abfa52942d77b1dac0dd38d54ed0e76c311a52"
    sha256 cellar: :any, arm64_sequoia: "0e6c57ce5aad591029a75887504ba8da456032bbfcf58f99ce2c643a38313d6f"
    sha256 cellar: :any, arm64_sonoma:  "afece122c6e2f7cd6d9fa10fc048ba180766cfa869b0688160f7300e2b6d4cbe"
    sha256 cellar: :any, sonoma:        "66f6127375f34afd6f2fcafeb5ffd95550a32718c388f1060f7934e76e213160"
    sha256 cellar: :any, arm64_linux:   "0da5d82c397a820b701610da5a6d7963cad3a1e2f9b4c6c182bb3a4b89f93801"
    sha256 cellar: :any, x86_64_linux:  "f86153d8d8a2238285668371f217282bfdea77bad2411db56320b3a9400787dd"
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

  post_install_steps do
    mkdir_p "log/icecast"
    touch "log/icecast/access.log"
    touch "log/icecast/error.log"
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
