class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.1.0.tar.bz2"
  sha256 "db9193b0f0255c24dfbfc31ecff8bd39e21fec05ff7526e5aea963abc517f0f3"
  revision 2

  bottle do
    sha256 "1d48743405a12dd6bb96212cedc37f51d9fbd5c4e78fb9ae6fb6b16c07d1a50d" => :high_sierra
    sha256 "7784b8e201277e41e1783e06d35e6011590aedfe5ddc8ab20e2bb33bc5784401" => :sierra
    sha256 "d5a9a66e92623890c3348be9b006b1f11e5bae289f2ab80af2831fdff7b34686" => :el_capitan
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
  depends_on :postgresql => :optional

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
