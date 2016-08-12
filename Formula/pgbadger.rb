class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://dalibo.github.io/pgbadger/"
  url "https://github.com/dalibo/pgbadger/archive/v8.2.tar.gz"
  sha256 "e4c596c021997aa2271300c57097f6e07814d3be49a96acf06b04bc35ede754e"

  head "https://github.com/dalibo/pgbadger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80dddbcc393ef42d336fee644345de03a364c01e8901f8ee078e8d932509de7e" => :el_capitan
    sha256 "39756e619f5671942cc279fffdcbac5ba43facb15c08da9e5afebfe5291890a1" => :yosemite
    sha256 "d057b3c13e60b5abc2c78564800f638341a46608d5e43f9ae36d8b71e0eed6a5" => :mavericks
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=#{buildpath}"
    system "make"
    system "make", "install"

    bin.install "usr/local/bin/pgbadger"
    man1.install "usr/local/share/man/man1/pgbadger.1p"
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
