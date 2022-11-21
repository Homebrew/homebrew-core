class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.33%20%28stable%29/privoxy-3.0.33-stable-src.tar.gz"
  sha256 "04b104e70dac61561b9dd110684b250fafc8c13dbe437a60fae18ddd9a881fae"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/privoxy[._-]v?(\d+(?:\.\d+)+)[._-]stable[._-]src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5298701701335108a58643a9c0db4a898372fda89e0fddca47f199490160391b"
    sha256 cellar: :any,                 arm64_monterey: "4d59937215ae6911b77ce1ca02608942c0b9ca7a18c38da89909fb9c3a6fe6e9"
    sha256 cellar: :any,                 arm64_big_sur:  "97cd684af21193fe0b7596860338af0b8a6a6f6f833475d92959b6ce75bce8fc"
    sha256 cellar: :any,                 ventura:        "2db1a4cb1ffb97f3cbd02cd9ca3eb40f5e31dddc85452797a0aebc4de6320043"
    sha256 cellar: :any,                 monterey:       "fd15bbf9ebf08d19f9212829def741754cc51b0394f5643dd0d3680008250827"
    sha256 cellar: :any,                 big_sur:        "0491266998ea099927d512de21e195ea356bcf09e2fb956a204f27a6f89c8226"
    sha256 cellar: :any,                 catalina:       "b19e5234b39ad38c70ab95f9763da0ee02e5b7978067f9662d2d15f3341a1e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e38d940bdb7370ec469171cd1aaa7de5ac98c52e2b4bdc42a4d0c92601544d0d"
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
