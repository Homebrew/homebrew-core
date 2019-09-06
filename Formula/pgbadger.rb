class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/v11.0.tar.gz"
  sha256 "ec295214fb4dba7762082cfd1ea2491e23a5fa5ecc3590fcfd6fc6b8d229d174"
  head "https://github.com/darold/pgbadger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f238750cdba335bcd27f62939e4929fca425b034c364fead9abae1570ea0a61" => :mojave
    sha256 "7cffd7a731f1849b17a7b416d137fab4319aaa4947c4d253cc6e4841f050f3bc" => :high_sierra
    sha256 "42f8ff435e762aaef6be3ccfe72f2181b2d5ec27e2bb52669026960f2651a7e4" => :sierra
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=#{buildpath}"
    system "make"
    system "make", "install"

    bin.install "usr/local/bin/pgbadger"
    man1.install "usr/local/share/man/man1/pgbadger.1p"
  end

  def caveats; <<~EOS
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
