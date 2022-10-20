class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/v12.0.tar.gz"
  sha256 "aaac57a573cf769e56d521bfe51c292a1290cb896f67a8751ffaa4db12f1f843"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bcd3b8f62218ce246438b4db5cc1de58e1a867ee686ed9c3eed58dd5adbf385"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2be5e5aef3f6d2e8e857bc51dfa13bd6fe17298230f331f8f12c0dabae5e0072"
    sha256 cellar: :any_skip_relocation, monterey:       "b327496a367e2b1052aea29d39331a2eebbdc5da9fc50dbefc5816ce108fdd7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3c2cf996a8c2d629aa0007a9e28fe1eea673718dab9da7f2a14d88f751064c3"
    sha256 cellar: :any_skip_relocation, catalina:       "bc4167d80d7d0f517ebda656f587b73eeb8e7bbe7ea134c06f4e3e9f521cd1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed28021e95bfa1b63956a894e5ed31fe18b17c96f7dcf9ade29a954505ec9f66"
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
