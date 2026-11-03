class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/refs/tags/v13.3.tar.gz"
  sha256 "a75368365056b129a7a74291a2af57f88a5fd423961cbb304790a09e8007dcef"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32d54a823d4dcfc9e32f85cdaba1b14257816d67127a5159f3c495d846592238"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "32d54a823d4dcfc9e32f85cdaba1b14257816d67127a5159f3c495d846592238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "32d54a823d4dcfc9e32f85cdaba1b14257816d67127a5159f3c495d846592238"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "522d812c4c0122910b224b2f76b713fc5a94c78c143c7c7c7215dbf216d6c54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "522d812c4c0122910b224b2f76b713fc5a94c78c143c7c7c7215dbf216d6c54c"
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
    assert_path_exists testpath/"out.html"
  end
end
