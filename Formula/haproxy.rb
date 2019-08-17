class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.0/src/haproxy-2.0.5.tar.gz"
  sha256 "3f2e0d40af66dd6df1dc2f6055d3de106ba62836d77b4c2e497a82a4bdbc5422"

  bottle do
    cellar :any
    sha256 "c8556b54a53a351f40108c70f95422fd1f3df37ec73bb21537d390f7fdbf114d" => :mojave
    sha256 "c0143d9e9757a8cafd87e1c26b9b86f5628d95db5f16dbb810bff061647b5e22" => :high_sierra
    sha256 "6846003f9d4788e46a6c564882f0ca84abb1e3eb77e20f402f4706c6fc83cdb9" => :sierra
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
