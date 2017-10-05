class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.0.4.tar.bz2"
  sha256 "d974ab89de69477c7f581a3233bc731eacbb43d479291e472b2c531c83b6d763"

  bottle do
    sha256 "e30011fbb145b6f218f162446110bdc9fc2e97042ee9e3579d1a76042f49c2f2" => :sierra
    sha256 "ed5aa3cc7ad6be4eaf2014e55a2710421f26a810538205a7b66b146e7f36649b" => :el_capitan
    sha256 "f0129da95db9a27333c4c047ecaa0407a60c83a755a71137d54328f564c204b6" => :yosemite
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

  # Use upstream commit that fixes build with Xcode 9
  # https://github.com/PowerDNS/pdns/pull/4940
  patch do
    url "https://github.com/PowerDNS/pdns/commit/885bddbd.patch?full_index=1"
    sha256 "a6c08599f8b6e368eaec99614e09da49be213666850c44101673fe2b3b4c2558"
  end

  def install
    args = %W[
      --prefix=#{prefix}
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

  def plist; <<-EOS.undent
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
