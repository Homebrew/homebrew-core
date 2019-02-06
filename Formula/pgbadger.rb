class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/v10.2.tar.gz"
  sha256 "90d8a7795b8be80ba2d7b9b1d69e15a0d94f44182a50f4790bfc5121d88a39f3"
  head "https://github.com/darold/pgbadger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "315118fab00e0a511d9cc19c112ac6cdd607a97f76c493525a1a991cf1f68b28" => :mojave
    sha256 "a8b5bdda8217248967eaca40aa084ae2e810377327099bc9c96676e7df3425a4" => :high_sierra
    sha256 "a8b5bdda8217248967eaca40aa084ae2e810377327099bc9c96676e7df3425a4" => :sierra
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
