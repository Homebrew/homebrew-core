class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://dalibo.github.io/pgbadger/"
  url "https://github.com/dalibo/pgbadger/archive/v9.0.tar.gz"
  sha256 "67ad3f016d60c33fc4fc92d42a27ea58d9b841b65f09a3d9e0a9a868ed462bbc"

  head "https://github.com/dalibo/pgbadger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a2278d4983103b47347e33f39e64e2c1ad2fff00153ec4e060d51066e73e450" => :sierra
    sha256 "f8480d4772d55018ea41d9b1975b34dceee74276c9bcac33a2ed2be1a309b872" => :el_capitan
    sha256 "8325aefb876b3eed969e41b3dc7b5869ef9b042dd08762081006c6fff08020a0" => :yosemite
    sha256 "224ef7a780e9f624ea3f256b2554e5125b288a62ec92b68923213fadb8d186b8" => :mavericks
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
