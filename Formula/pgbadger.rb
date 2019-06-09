class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/v10.3.tar.gz"
  sha256 "361ff552b207b0b31108181add98b374ed19aca6f25eed2d217fef070f083917"
  head "https://github.com/darold/pgbadger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb3663d8f99b32154a406e373ef3ce96634827df7815bd5c8fdf94691802f2a8" => :mojave
    sha256 "143849e39e8eefe99997c6146530948c6b1d443bfb10abaafb56161ba36cd36b" => :high_sierra
    sha256 "cc0df751bc5849e7c46c64dc6ed4a648087a47a21e16d5db208c0cc4b06df3e2" => :sierra
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
