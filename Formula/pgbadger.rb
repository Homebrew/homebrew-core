class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://dalibo.github.io/pgbadger/"
  url "https://github.com/dalibo/pgbadger/archive/v8.1.tar.gz"
  sha256 "db71fe98e00a6b05990a5e4624a6e2d37789201ec3d7697ff0db82ed4b027299"

  head "https://github.com/dalibo/pgbadger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "feb2378a21fd63c97251dfa38e49355ae0adfb795ed95783e9b1011305fa3cb9" => :el_capitan
    sha256 "d4bfb4f6ba8ff2251e3fe1618834d6de712dc4fb682e41936f75f0dcc5dd76c0" => :yosemite
    sha256 "fab02f061a2402f6cb1a6b7fc14b19b5bdf35d88d2bad40b161c4127e014c063" => :mavericks
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=#{buildpath}"
    system "make"
    system "make", "install"

    bin.install "usr/local/bin/pgbadger"
    man1.install "usr/local/share/man/man1/pgbadger.1p"
    chmod 0755, bin+"pgbadger" # has 555 by default
    chmod 0644, man1+"pgbadger.1p" # has 444 by default
  end

  def caveats; <<-EOS.undent
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
    (testpath/"server.log").write <<-EOS.undent
      LOG:  autovacuum launcher started
      LOG:  database system is ready to accept connections
    EOS
    system bin/"pgbadger", "-f", "syslog", "server.log"
    assert File.exist? "out.html"
  end
end
