class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.9/src/haproxy-1.9.4.tar.gz"
  sha256 "8483fe12b30256f83d542b3f699e165d8f71bf2dfac8b16bb53716abce4ba74f"

  bottle do
    cellar :any
    sha256 "f7fb5817c7c95c7c2a87c049de2c935693264131ada4c1305066ccd96f0b08f0" => :mojave
    sha256 "e88abbe9f9db6833d50d6f4cba611002ddf90d34540e5c43bd1c46122503eed0" => :high_sierra
    sha256 "65117861a4d041027c104d967dcb1ba2e1a10ed9fb39bfd29679b2b89ea7f826" => :sierra
  end

  depends_on "openssl"
  depends_on "pcre"

  # Patch for BUILD/MEDIUM: initcall: Fix build on MacOS. See haproxy/haproxy#42
  # Should be safe to remove on > 1.9.4 release as upstream intend to backport
  patch do
    url "https://github.com/haproxy/haproxy/commit/9efa7b8.patch?full_index=1"
    sha256 "756b26d3518cbf9a84f5957719beb764ac4d25bdb783f839d5b05c5283ac2f62"
  end

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
