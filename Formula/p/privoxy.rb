class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.34%20%28stable%29/privoxy-3.0.34-stable-src.tar.gz"
  sha256 "e6ccbca1656f4e616b4657f8514e33a70f6697e9d7294356577839322a3c5d2c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/privoxy[._-]v?(\d+(?:\.\d+)+)[._-]stable[._-]src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4ec5910c8e67367112560e96440ab88fdee51cf3c276d41565ab5cce5bd90d51"
    sha256 cellar: :any,                 arm64_sonoma:   "2d271db67276295a3c0a95713d1bef904015c7729615380ada8f9228196b2632"
    sha256 cellar: :any,                 arm64_ventura:  "9e9553d35f57d1857a1518216b4263eb9ffce10cf9e93da7a38f688f23606610"
    sha256 cellar: :any,                 arm64_monterey: "1b0028627cbd63a818a043537b4357b7bb0105fb56ba0b4d92efe3300cc953f9"
    sha256 cellar: :any,                 arm64_big_sur:  "583123f742ab84d72e189867ec920940e7ecada0cd4bec3dbb7c2784b51e2b9e"
    sha256 cellar: :any,                 sonoma:         "5d97667b9c9fbb87ca967ae879c8ae53bda5e56d9870580e3ad04baa6c6f9537"
    sha256 cellar: :any,                 ventura:        "6dbe6c6a8868cf03772a719adfd6c49bfd7da372067147994c56a9c629c7ff0e"
    sha256 cellar: :any,                 monterey:       "317d73bfe1c16bf887be0627f7aa27f543aa61dc8d1c9748cac74b11abbc0b14"
    sha256 cellar: :any,                 big_sur:        "46df2df9e4dcaf3f16ba6540fdc8432db8395d5fd03fc9a6fe51c9629e216be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4b3fcb5f8fd5f5479462ae9db4fb99a300dab2005b3f383b78f13cb6a8eed4f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  def install
    # Find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    # No configure script is shipped with the source
    system "autoreconf", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/privoxy",
                          "--localstatedir=#{var}"
    system "make"
    system "make", "install"
  end

  service do
    run [opt_sbin/"privoxy", "--no-daemon", etc/"privoxy/config"]
    keep_alive true
    working_dir var
    error_log_path var/"log/privoxy/logfile"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    (testpath/"config").write("listen-address #{bind_address}\n")
    begin
      server = IO.popen("#{sbin}/privoxy --no-daemon #{testpath}/config")
      sleep 1
      assert_match "HTTP/1.1 200 Connection established",
                   shell_output("/usr/bin/curl -I -x #{bind_address} https://github.com")
    ensure
      Process.kill("SIGINT", server.pid)
      Process.wait(server.pid)
    end
  end
end
