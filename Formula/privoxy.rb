class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.29%20%28stable%29/privoxy-3.0.29-stable-src.tar.gz"
  sha256 "25c6069efdaf577d47c257da63b03cd6d063fb790e19cc39603d82e5db72489d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/privoxy[._-]v?(\d+(?:\.\d+)+)[._-]stable[._-]src\.t}i)
  end

  bottle do
    cellar :any
    sha256 "7b49313bc0ca6074e83753c56c192cc8c922e63f37a07ffd6954d81f63b39e69" => :big_sur
    sha256 "08590216716f79252f4485179965c2a41a5db7064f86e575874a85dccda4adaa" => :arm64_big_sur
    sha256 "8e6f41dd3f0828b17ed3ee516de139ae4baa66d7c01c633bf3fc95097029e5a8" => :catalina
    sha256 "8c382bc37d0a27ca33786a09e435942f38aac55bb48b22f4dafe8810002a06da" => :mojave
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

  plist_options manual: "privoxy #{HOMEBREW_PREFIX}/etc/privoxy/config"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/privoxy</string>
          <string>--no-daemon</string>
          <string>#{etc}/privoxy/config</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/privoxy/logfile</string>
      </dict>
      </plist>
    EOS
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    (testpath/"config").write("listen-address #{bind_address}\n")
    begin
      server = IO.popen("#{sbin}/privoxy --no-daemon #{testpath}/config")
      sleep 1
      assert_match "200 OK", shell_output("/usr/bin/curl -I -x #{bind_address} https://github.com")
    ensure
      Process.kill("SIGINT", server.pid)
      Process.wait(server.pid)
    end
  end
end
