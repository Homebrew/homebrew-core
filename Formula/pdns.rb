class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.0.3.tar.bz2"
  sha256 "60fa21550b278b41f58701af31c9f2b121badf271fb9d7642f6d35bfbea8e282"
  revision 1

  bottle do
    rebuild 1
    sha256 "1cbf7b9fee0547821a2e1272024a8f422f3a7d29352189fd31350058a48a9fa1" => :sierra
    sha256 "21d3740b76c2db623bd0af082b19428491a8015ceb66a43b63ddc2bb0e582442" => :el_capitan
    sha256 "b16f12210c373ed1c75b620617a59c74b5b458f7e151fe1ac5483e33586b42ed" => :yosemite
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  option "with-postgresql", "Enable the PostgreSQL backend"

  deprecated_option "pgsql" => "with-postgresql"
  deprecated_option "with-pgsql" => "with-postgresql"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl"
  depends_on "sqlite"
  depends_on :postgresql => :optional

  def install
    # FIXME: needs a /var/run dir option
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/pdns
      --localstatedir=#{var}
      --with-socketdir=#{var}/run
      --with-lua
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-sqlite3
    ]

    # Include the PostgreSQL backend if requested
    if build.with? "postgresql"
      args << "--with-modules=gsqlite3 gpgsql"
    else
      # SQLite3 backend only is the default
      args << "--with-modules=gsqlite3"
    end

    system "./bootstrap" if build.head?
    system "./configure", *args

    system "make", "install"
    (var/"log/pdns").mkpath
    (var/"run").mkpath
  end

  plist_options :manual => "pdns_server start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/pdns_server</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <dict>
        <key>Crashed</key>
        <true/>
      </dict>
      <key>StandardErrorPath</key>
      <string>#{var}/log/pdns/pdns_server.err</string>
      <key>StandardOutPath</key>
      <string>/dev/null</string>
    </dict>
    </plist>
    EOS
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
