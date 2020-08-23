class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.2/src/haproxy-2.2.2.tar.gz"
  sha256 "391c705a46c6208a63a67ea842c6600146ca24618531570c89c7915b0c6a54d6"

  bottle do
    cellar :any
    sha256 "865f798fe6012ec2b9badf0446e264a14354cec95cbf9e0cb93dde58f3052d69" => :catalina
    sha256 "03d016685f2b6af6693cb59a87aa7a912680cc77f6e70592c94ebb3570726f22" => :mojave
    sha256 "a816df737155aada46f2199d91c0215abb6d193ed8b9d26a7db6fa2bcf7693b0" => :high_sierra
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

  plist_options manual: "haproxy -f #{HOMEBREW_PREFIX}/etc/haproxy.cfg"

  def plist
    <<~EOS
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
