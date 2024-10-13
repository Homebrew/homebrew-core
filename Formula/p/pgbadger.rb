class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/refs/tags/v12.4.tar.gz"
  sha256 "25456f0ea76e1de946d2bf09d937e9e830ca953ae4544a72bb9b747f11b4711a"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5f0868106355ade8dd3c388738f195b5af0117bbea2853ffa2a28356be381873"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a1ef5586c181e4549202e3aa9f6444d9ec21e47497051683b433120eaf94923"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2e5eec08628c0632b59f62169324beb9cf343c5f5a6207db97fef1ebd91b2b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2e5eec08628c0632b59f62169324beb9cf343c5f5a6207db97fef1ebd91b2b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cc96eaa419d1c2d0beb889d8603412a5b3e39da4904c0b388ee88c0765d00e2"
    sha256 cellar: :any_skip_relocation, ventura:        "4457fc2186c89bcb409c8b981918a58b80e72acfc79cb6f2696478fef6b1f6ad"
    sha256 cellar: :any_skip_relocation, monterey:       "4457fc2186c89bcb409c8b981918a58b80e72acfc79cb6f2696478fef6b1f6ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceb310563679b39f4c7b18a253e2aef5f6e0d24cb7d428e28e4bfc4e1eac5ea0"
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
