class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.1.1.tar.bz2"
  sha256 "08d388321c8a2c24ebe8d7e539f34a0ba2c0973313c168a1b5ecf507e4fb04ba"

  bottle do
    sha256 "470c9841912c8c2ef96c69c8426b4cfc17d10277c978c193015261d677c87651" => :high_sierra
    sha256 "857cb0232f168326f27f696b9ba2c1c1fe6577b21dcbca4f2179cdcae379704d" => :sierra
    sha256 "1e22069fb9c9b263a75f2361602d87923f72094225fa27ba4662b3a8bd1f2566" => :el_capitan
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  option "with-postgresql", "Enable the PostgreSQL backend"
  option "with-remote", "enable the Remote backend"

  deprecated_option "pgsql" => "with-postgresql"
  deprecated_option "with-pgsql" => "with-postgresql"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl"
  depends_on "sqlite"
  depends_on "postgresql" => :optional

  def install
    # Fix "configure: error: cannot find boost/program_options.hpp"
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-sqlite3
    ]

    # Include the PostgreSQL backend if requested
    if build.with? "postgresql"
      args << "--with-modules=gsqlite3 gpgsql"
    elsif build.with? "remote"
      args << "--with-modules=gsqlite3 remote"
    else
      # SQLite3 backend only is the default
      args << "--with-modules=gsqlite3"
    end

    system "./bootstrap" if build.head?
    system "./configure", *args

    system "make", "install"
  end

  plist_options :manual => "pdns_server start"

  def plist; <<~EOS
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
        <string>#{opt_bin}/pdns_server</string>
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
