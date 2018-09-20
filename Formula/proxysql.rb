class Proxysql < Formula
  desc "High Performance Advanced Proxy for MySQL"
  homepage "http://www.proxysql.com/"
  url "https://github.com/sysown/proxysql/archive/v1.4.11.tar.gz"
  sha256 "9d34be2916e4b341820d2e9346a4697464e70d6ae1fb2a0761006299c96067c8"

  # Build dependencies listed here: https://github.com/sysown/proxysql/blob/master/INSTALL.md
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "mysql" => :test
  depends_on "openssl"

  def install
    system "make"
    # Currently, the Proxysql build system uses fixed paths for install locations.
    # See https://github.com/sysown/proxysql/blob/master/Makefile
    # The 'make install' target would need to be patched to support Homebrew.
    # Configurable target locations are requested in https://github.com/sysown/proxysql/issues/1565
    bin.install "src/proxysql"
    etc.install "etc/proxysql.cnf"
    (var/"lib/proxysql").mkpath
    inreplace etc/"proxysql.cnf", 'datadir="/var/lib/proxysql"', %Q(datadir="#{var}/lib/proxysql")
  end

  plist_options :manual => "proxysql"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/proxysql</string>
          <string>--foreground</string>
          <string>--config</string>
          <string>#{etc}/proxysql.cnf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    system bin/"proxysql", "--help"
    begin
      background_proxysql = fork do
        exec "#{bin}/proxysql", "-f", "-S", "#{testpath}/admin.sock", "-c", "#{etc}/proxysql.cnf", "--initial", "-D", testpath
      end
      # Sleep until the proxy is up (querying it prematurely causes a segfault), then check its uptime.
      sleep 1
      output = pipe_output(
        "mysql -uadmin -padmin -S#{testpath}/admin.sock --default-auth=mysql_native_password",
        "select * from stats.stats_mysql_global",
        0,
      )
      assert_match /ProxySQL_Uptime\s+[1-9]\d*/, output
    ensure
      Process.kill("TERM", background_proxysql)
    end
  end
end
