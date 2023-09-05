class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/refs/tags/v12.2.tar.gz"
  sha256 "86677cb11d0fbcd80ed984c253318cf4b5f2e9ae11211c4b40606cf4536fb4b3"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43fdc11961083b2fe26404ec3cf1db0f385bed9d7790c507309d9102fd65cbae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43fdc11961083b2fe26404ec3cf1db0f385bed9d7790c507309d9102fd65cbae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ef944f78b90a0325f1ab62b6754e28bb5178ad6eae0daaf5d3c028265419b44"
    sha256 cellar: :any_skip_relocation, ventura:        "1d9a26125895ff45d1f63e31cd90d0b92fb598c92fdf3b3d38ab7dfc7e95f4c9"
    sha256 cellar: :any_skip_relocation, monterey:       "1d9a26125895ff45d1f63e31cd90d0b92fb598c92fdf3b3d38ab7dfc7e95f4c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "deb782255ba028c3ce3909bbf492f891cac710b248364473a9230fc9752fa345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21b8b6e6d51f3154cb2ade19831c0317b5d274b5c0506b8a875e8cef9864fb04"
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
