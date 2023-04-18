class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/v12.1.tar.gz"
  sha256 "4c2e43b93b72383bfc9a123d5fcda4f74147c1184e1d74c06498973b4b91629e"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b76042d0c7d6aea2eef0c828d84fe5603c3157ab46425c75fcced5cef211c5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b76042d0c7d6aea2eef0c828d84fe5603c3157ab46425c75fcced5cef211c5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "529f6d56a5cc31782c9722a32d7613c66c156efa76bb8cc4717430b8d96ab9e0"
    sha256 cellar: :any_skip_relocation, ventura:        "140c8a00b3973c25393cc55c034b9b9411ad9a1b835f5515ec9d9d7c87468b0e"
    sha256 cellar: :any_skip_relocation, monterey:       "140c8a00b3973c25393cc55c034b9b9411ad9a1b835f5515ec9d9d7c87468b0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bfc5717772bd45d444fbe83bd0c39d17849d7f9271790c1f75cd8891063acdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae3029f8cb34f69c3086db58e6c24f8326cb99ec88ee9b788a0099a67d9800d0"
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
