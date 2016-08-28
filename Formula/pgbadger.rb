class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://dalibo.github.io/pgbadger/"
  url "https://github.com/dalibo/pgbadger/archive/v8.3.tar.gz"
  sha256 "a560bfb1da490325e922b291d5204bdb20c4f4a2456f77d610989d13ad1e3a4d"

  head "https://github.com/dalibo/pgbadger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed123ca8ce80164885a2aca6399651b39bd558225022d5786124d546709eb7bf" => :el_capitan
    sha256 "57d78cfaf000e4f70b05e9d76c357856e791e2b3df9200b46710653551f7cd14" => :yosemite
    sha256 "f5d9e1e741afc4fad7b9f4d3138c02ec98cc12ef6c8cd26e785d231820c94f50" => :mavericks
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
