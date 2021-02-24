class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/v11.5.tar.gz"
  sha256 "49ab18810a61353ebd7fee12b899ccb9adfd064be6099084670b945db5ff1186"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e746195e6003286f5ffc6e9af6445a3078d7e53b06351ba272e77efecda17041"
    sha256 cellar: :any_skip_relocation, big_sur:       "47dd580296d42a158b6e11853790080a6ec9408ece3f69d66672050f89753a19"
    sha256 cellar: :any_skip_relocation, catalina:      "751904911636d8e1e4c8714f6c41d0aa9b56b703fc78dd024e8df1b67807f977"
    sha256 cellar: :any_skip_relocation, mojave:        "0684dc2d96a3e715f58050c0c05d037a185cced9d0a36d970d6e0f7feffe7d0a"
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=#{buildpath}"
    system "make"
    system "make", "install"

    bin.install "usr/local/bin/pgbadger"
    man1.install "usr/local/share/man/man1/pgbadger.1p"
  end

  def caveats
    <<~EOS
      You must configure your PostgreSQL server before using pgBadger.
      Edit postgresql.conf (in #{var}/postgres if you use Homebrew's
      PostgreSQL), set the following parameters, and restart PostgreSQL:

        log_destination = 'stderr'
        log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d '
        log_statement = 'none'
        log_duration = off
        log_min_duration_statement = 0
        log_checkpoints = on
        log_connections = on
        log_disconnections = on
        log_lock_waits = on
        log_temp_files = 0
        lc_messages = 'C'
    EOS
  end

  test do
    (testpath/"server.log").write <<~EOS
      LOG:  autovacuum launcher started
      LOG:  database system is ready to accept connections
    EOS
    system bin/"pgbadger", "-f", "syslog", "server.log"
    assert_predicate testpath/"out.html", :exist?
  end
end
