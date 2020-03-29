class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.28%20%28stable%29/privoxy-3.0.28-stable-src.tar.gz"
  sha256 "b5d78cc036aaadb3b7cf860e9d598d7332af468926a26e2d56167f1cb6f2824a"

  bottle do
    cellar :any
    sha256 "27fe56112d9fda97417f830b4c17a5066b4389f7831db250a702c91d8df62131" => :catalina
    sha256 "01d3b6f679a5819786936626ed093773d68094aa16a8969bf912a507690043f1" => :mojave
    sha256 "1dfa322367c0f6e5013f2a08fe12a825d4627b2c23aba0aecc94e65e10904700" => :high_sierra
    sha256 "cd9a919132c032f335f6c7bce15fc5a6abb24fbd56f7ee51884ea30aac710b67" => :sierra
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

  plist_options :manual => "privoxy #{HOMEBREW_PREFIX}/etc/privoxy/config"

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
    bind_address = "127.0.0.1:8118"
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
