class Proxysql < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "http://www.proxysql.com/"
  url "https://github.com/sysown/proxysql/archive/v1.4.9.tar.gz"
  sha256 "28ee75735716ab2e882b377466f37f5836ce108cfcfe4cf36f31574f81cce401"

  # Build dependencies listed here: https://github.com/sysown/proxysql/blob/master/INSTALL.md
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "make" => :build
  depends_on "mysql" => :test
  depends_on "curl"
  depends_on "openssl"

  # https://github.com/sysown/proxysql/pull/1564
  # TODO when the 1.4.10 release is cut, this formula should be updated and
  # this patch should be removed.
  patch do
    url "https://github.com/sysown/proxysql/compare/v1.4.10...zbentley:v1.4.10.diff?full_index=1"
    sha256 "c0beccc67a834b5eb2b9d2d70ac28556eaf0268cc456453c97e326e68c894622"
  end

  # Fixed upstream, not yet released.
  # TODO when the 1.4.10 release is cut, this formula should be updated
  # and this patch should be removed.
  patch do
    url "https://github.com/sysown/proxysql/commit/9dab0eba12a717b738264d6928599034ea3ebe81.diff?full_index=1"
  end

  def install
    system "make"
    # Currently, the Proxysql build system uses fixed paths for install locations.
    # See https://github.com/sysown/proxysql/blob/master/Makefile
    # The 'make install' target would need to be patched to support Homebrew.
    # Configurable target locations are requested in https://github.com/sysown/proxysql/issues/1565
    bin.install "src/proxysql"
    etc.install "etc/proxysql.cnf"
  end

  test do
    system bin/"proxysql", "--help"
    background_proxysql = fork do
      exec "#{bin}/proxysql", "-S", "admin.sock"
    end
    begin
      # Sleep until the proxy is up (querying it prematurely causes a segfault), then check its uptime.
      output = pipe_output("sleep 2; mysql -uadmin -padmin -S admin.sock stats < <( echo 'select * from stats.stats_mysql_global' )")
      assert_match /ProxySQL_Uptime\s+[1-9]\d*/, output
    ensure
      Process.kill("TERM", background_proxysql)
    end
  end
end
