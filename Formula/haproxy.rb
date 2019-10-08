class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.0/src/haproxy-2.0.7.tar.gz"
  sha256 "3873cd72028ed1bd2506dd174e01a92620e92683092f34234c96e067dcb113dc"

  bottle do
    cellar :any
    sha256 "7d173ed59879d255c5bb8aef347caf75c6246b8203198c02e121175988fc2140" => :catalina
    sha256 "7cbb2a35dfcc612a1c1ee5b0236a5427c87c4d76cb340f84e43c240a4d57c5e7" => :mojave
    sha256 "a5f0c4b210ad14a0d4e3882560b7a78e4c5566f60f4914e1bbbcb4d1768d24d4" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    args = %w[
      TARGET=generic
      USE_KQUEUE=1
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_THREAD=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  plist_options :manual => "haproxy -f #{HOMEBREW_PREFIX}/etc/haproxy.cfg"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/haproxy</string>
          <string>-f</string>
          <string>#{etc}/haproxy.cfg</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/haproxy.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/haproxy.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system bin/"haproxy", "-v"
  end
end
