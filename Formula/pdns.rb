class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.1.3.tar.bz2"
  sha256 "9aa5b37ded60bae99c0f3145e1562550869875346b882048e9aa04c25fc301ae"

  bottle do
    sha256 "eb351d17afb02275426c016b1bb67896c2d40a455772b5d21cc3e8d3f78471eb" => :high_sierra
    sha256 "2e13297e385b9777e37ef260f1da11e63c75b977afb4451211ea05daf4ce3127" => :sierra
    sha256 "ee93325621eab781cc718b26aef2734516338cec8182f3ed06311f847a3e20fc" => :el_capitan
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
