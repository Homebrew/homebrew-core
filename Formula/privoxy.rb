class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.31%20%28stable%29/privoxy-3.0.31-stable-src.tar.gz"
  sha256 "077729a3aac79222a4e8d88a650d9028d16fd4b0d6038da8f5f5e47120d004eb"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/privoxy[._-]v?(\d+(?:\.\d+)+)[._-]stable[._-]src\.t}i)
  end

  bottle do
    sha256 cellar: :any, big_sur: "6afd2d69f94fe21894e98ed6527f5b59b708e0549e975dba750f4f8bd7319e5b"
    sha256 cellar: :any, arm64_big_sur: "a31ccb4ed242cdb08eeb7f847dd22d0c5d561e50cf792d828db809005838cbee"
    sha256 cellar: :any, catalina: "e0a480997db3af1527a6458f3a64817daf963dc2f0fc38e8ea04ff7da9876a08"
    sha256 cellar: :any, mojave: "2a3156bbd30ebb8cb25eaaf796044d2e549fd96dfdfc921d0f41ab2f85fd6625"
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
