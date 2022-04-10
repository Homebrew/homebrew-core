class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/v11.8.tar.gz"
  sha256 "ddf4714ac058e0170359af43c22addcc0872ae17ba6f15c4e3c5a71be3b68291"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa6599ec6806a98198c1965441170aa992cefe49290d20403d97eacca844726a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6d8e5e81474357fa5c9766e0c189cd654b2bd8562a725d02ace7a00908a1272"
    sha256 cellar: :any_skip_relocation, monterey:       "38ac50ca7dda1eec18d358dc15a1e55c3f97b333dbed043931c12bd1f1b09a9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "26fc168dfc354e7ec433e82100f5cf017ff32f53190ffa5273e880658e6853d4"
    sha256 cellar: :any_skip_relocation, catalina:       "5f1b4adb05e165887f8fac5eeb995725d48752e0fcb8331b3c35652fcd6fa3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b31595e6e729b5f73682ff7c813f3b4c7f33b79fe65580a6c268557f90266c4a"
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=#{buildpath}"
    system "make"
    system "make", "install"

    man_dir = if OS.mac?
      "share/man/man1"
    else
      "man/man1"
    end
    bin.install "usr/local/bin/pgbadger"
    man1.install "usr/local/#{man_dir}/pgbadger.1p"
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
