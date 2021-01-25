class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/v11.4.tar.gz"
  sha256 "b235b540fe4bbc7cf59274b82ad427022ea378812562bd2c350353c884ee0bfd"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4e3aec248f7f8a4ca22d2d8f1d7081957d9563a08c1306b4f3e181b5b3f9731" => :big_sur
    sha256 "4fdbd023b1c74fe88fc21499648fc1d1629e973ee2f302dd0fee99cfff02602f" => :arm64_big_sur
    sha256 "0fbecf1eeb0625fcb19d063caa0c5e81941ef36a8a634e2597a6fb13f0511836" => :catalina
    sha256 "a7d21722b811c186a5908514f3b310a99983ecd4e8782f8698bab15610550edb" => :mojave
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
