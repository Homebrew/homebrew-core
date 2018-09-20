class Proxysql < Formula
  desc "High Performance Advanced Proxy for MySQL"
  homepage "http://www.proxysql.com/"
  url "https://github.com/sysown/proxysql/archive/v1.4.10.tar.gz"
  sha256 "29020cba75b778ef45b06c5469ee5930ce80afbd0290a112d8c2a6652b4c8a2e"

  # Build dependencies listed here: https://github.com/sysown/proxysql/blob/master/INSTALL.md
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "make" => :build
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
    inreplace etc/"proxysql.cnf" do |s|
      s.gsub! "datadir=\"/var/lib/proxysql\"", "datadir=\"#{var}/lib/proxysql\""
    end
    
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
        0
      )
      assert_match /ProxySQL_Uptime\s+[1-9]\d*/, output
    ensure
      Process.kill("TERM", background_proxysql)
    end
  end
end
