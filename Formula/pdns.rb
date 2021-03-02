class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.4.1.tar.bz2"
  sha256 "03fa7c181c666a5fc44a49affe7666bd385d46c1fe15088caff175967e85ab6c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "41d4db1f974f4139abf4e064c33c98e0b31d47fb3be3e062e482f37449a326c4"
    sha256 big_sur:       "3462eb24c8379733f29bdc2fa6177cdf643aecbfc5fbe58ac3d5f9129a32befe"
    sha256 catalina:      "b3caacf5599b6a71a88daabb7c7ce5ec606f75ad7378e57a8eb0e19935923c19"
    sha256 mojave:        "03a2e4848800803555e0e2ea398de47b0172f96a82412b83e0629a62979dd6e7"
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "sqlite"

  uses_from_macos "curl"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options manual: "pdns_server start"

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
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/pdns_server</string>
        </array>
        <key>EnvironmentVariables</key>
        <key>KeepAlive</key>
        <true/>
        <key>SHAuthorizationRight</key>
        <string>system.preferences</string>
      </dict>
      </plist>
    EOS
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
