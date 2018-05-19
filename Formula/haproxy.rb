class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.8/src/haproxy-1.8.9.tar.gz"
  sha256 "436b77927cd85bcd4c2cb3cbf7fb539a5362d9686fdcfa34f37550ca1f5db102"

  bottle do
    cellar :any
    sha256 "3b3235039c8eb6d47bcb2ffc505be845229810dda4dac26e3d6199d04a993446" => :high_sierra
    sha256 "3fd16eb92ac3e942ed2f328b46fd2d7bd289c7c9f1efc4010da2f6664e27fdd8" => :sierra
    sha256 "969a9baf73b31c8ec36758f721342ea1143b30a54d28ed1645ce45b1adedb958" => :el_capitan
  end

  depends_on "openssl"
  depends_on "pcre"
  depends_on "lua" => :optional

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

    if build.with?("lua")
      lua = Formula["lua"]
      args << "USE_LUA=1"
      args << "LUA_LIB=#{lua.opt_lib}"
      args << "LUA_INC=#{lua.opt_include}"
      args << "LUA_LD_FLAGS=-L#{lua.opt_lib}"
    end

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
