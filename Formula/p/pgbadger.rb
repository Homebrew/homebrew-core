class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/refs/tags/v13.1.tar.gz"
  sha256 "9658ff222ed7b387d3cb76c3e3d90d1862b885c13b26aa9ff652e133f5d018f1"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3e83fad1caf40cefd5ac3dd5d536286e5d1de2ba73cacb5c91de04ff359088f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3e83fad1caf40cefd5ac3dd5d536286e5d1de2ba73cacb5c91de04ff359088f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aaffda73eea02684a47c7e8fbba2d1ba4787be1cea304204a938408fa3ea9022"
    sha256 cellar: :any_skip_relocation, sonoma:        "93fe9851cb986a58f8db18251ec636ab6e09d317f0813bbc7600b65f5989d284"
    sha256 cellar: :any_skip_relocation, ventura:       "5fd44b906bbbbfa63e11b886b1514b97f2913d73a026d132f4cf84cbe4811657"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24267f87df6ab44c1a9abd0b000338804af5514d865d7a82c1101bb9a9ae96d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24267f87df6ab44c1a9abd0b000338804af5514d865d7a82c1101bb9a9ae96d3"
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
