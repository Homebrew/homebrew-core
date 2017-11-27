class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.8/src/haproxy-1.8.0.tar.gz"
  sha256 "07b6e041b477c01543fd365cb7e7fc1b7219e0f86d810828eedd593ae98b6ca0"

  bottle do
    cellar :any
    sha256 "79af48600b3a69bc8617613abd520b1b95c33fa22fe88214871ae92c81505be0" => :high_sierra
    sha256 "f27784d7dee1e22ca45cc396479341c9fd3daec90832b5004d732b2fb7d808f0" => :sierra
    sha256 "6cbe3f8dcb16ff84fb93a14bff0c47e5920a0b95d6c61469d5672740fbd690cf" => :el_capitan
    sha256 "f6f9d3853bbfd4eaf5000af53f6da78e0e694559ad2a30d6f21db08a88f00d60" => :yosemite
  end

  depends_on "openssl"
  depends_on "pcre"

  def install
    args = %w[
      TARGET=generic
      USE_KQUEUE=1
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
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
