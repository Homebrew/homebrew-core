class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.5.2.tar.bz2"
  sha256 "93d94a2500b1b3288dde0e76da7c40095382d93f0998d0f15449d1e6fc033641"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "41011b1c1053086572278aaeb850b6bd8878a60ecb949cc174f42215a1d9ab56"
    sha256 arm64_big_sur:  "0bf7af4af497448cc1fb444ed7a445a98e1cd0e2dd7dd037f5c078979828b0f4"
    sha256 monterey:       "606a6103e2ad2350d0b38207ab8106298854fe8cf54c163043b038f39598ff38"
    sha256 big_sur:        "fa4ac0b0c0cacdcced6f1d76d7e42c9212bd1046eac21740b448e8b8380463ba"
    sha256 catalina:       "6c33506fa12dcb0a883636848a3ea8ab4e42b0e05ad5c43b5d131266c5a8eaf0"
    sha256 mojave:         "75073ee3c30ec52a2aa8358582a9c5e3933b346505aad6b1715c4105951ecfb4"
    sha256 x86_64_linux:   "e5434cd26faa2eaed3a978448e6a216ee2df124a8cb491b04987f7ce3536e808"
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

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

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
