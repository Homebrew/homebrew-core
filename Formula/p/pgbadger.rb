class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/refs/tags/v13.0.tar.gz"
  sha256 "4cfaa24e6e7623e3f54e4a9dc35cc8030f7d2486931dc018d677d73181ba3626"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94aa1fdd34d44e52c4b8a61de9aa2d4f93e31108c00086c6fad2bd89e8203096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94aa1fdd34d44e52c4b8a61de9aa2d4f93e31108c00086c6fad2bd89e8203096"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "777f851682d287a083d4e77c240fc8675070df16bfeb868750d249213d3168eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c858ea71c3dc74d999c1d64f5e5225963dabf18136444bf8f4ffd4a1d9c1584b"
    sha256 cellar: :any_skip_relocation, ventura:       "2963fb8da4935daae96d8a17a7abb70b4a1c5173c5d25b5593029d600a092fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "997a32aa91ebc0335121777abc59b8701f132ec87611be733d0f36d8d241500e"
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
