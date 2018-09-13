class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/v10.1.tar.gz"
  sha256 "cf8993bf557504fb935a1da737a4b1f0a36dfcf13525a039faa6ce3eb940e276"
  head "https://github.com/darold/pgbadger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d37480b014b1ab14c23fc32bbc5f9905f698278a7f992bb3936f407e2a376c1" => :mojave
    sha256 "84d415f357636d23074da0d3d07f44a16408657d6a948dd5028cb2ef6d7c279f" => :high_sierra
    sha256 "84d415f357636d23074da0d3d07f44a16408657d6a948dd5028cb2ef6d7c279f" => :sierra
    sha256 "84d415f357636d23074da0d3d07f44a16408657d6a948dd5028cb2ef6d7c279f" => :el_capitan
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
