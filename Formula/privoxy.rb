class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.32%20%28stable%29/privoxy-3.0.32-stable-src.tar.gz"
  sha256 "c61de4008c62445ec18f1f270407cbf2372eaba93beaccdc9e3238bb2defeed7"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/privoxy[._-]v?(\d+(?:\.\d+)+)[._-]stable[._-]src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4f47a51f90263ff04dee352f7093a9796e0b38e108776c13cb59fca9704b680f"
    sha256 cellar: :any,                 arm64_big_sur:  "c30372261661ab924bd6e3df9c86804d188dd130d0810e55e81aaa3431f924df"
    sha256 cellar: :any,                 monterey:       "554540c71eec094dcaec79a71bd98c77efebae9f09a1a810d0616e8bbedd2c21"
    sha256 cellar: :any,                 big_sur:        "2edd70c7227801bd01df3b6ee756802daa63d8567c3d7d79bceb80233f18bbff"
    sha256 cellar: :any,                 catalina:       "b6b4b6fb269021a16685b7ee407ff8384699cf05910d3afbfac191afd6f1e588"
    sha256 cellar: :any,                 mojave:         "d7302bde6de73110eff0a8e86554414641d7a2eac7ebe4aff54956f7609acc5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7d8a8671f959df63a6af51510e044ea179b947b1a2c38b954804cf9950877e"
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
