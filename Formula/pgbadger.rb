class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/v11.6.tar.gz"
  sha256 "9c8744f76123021c2d15da8521d77b3f529e50702fb3518c4d0e0311e457a3ec"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "407cc95231c8ecb69b60d6e2b2947deee4ab1cf8df30d7e7bbfa0e7fa918437b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fea3dce312139a44c49a6591af532b8463f798cfdaca19107b19a24e21a92d86"
    sha256 cellar: :any_skip_relocation, monterey:       "26e871f3cc1802bff8a92bb086df07fa96795e77d22fb2a93aa980ffb23b9aed"
    sha256 cellar: :any_skip_relocation, big_sur:        "354a71298cbd1d666fd5680e1e146f151c9a64babc067530b9c23f06ac49c844"
    sha256 cellar: :any_skip_relocation, catalina:       "70b715507e7d1a6daa76613ad2cd6a1fb41a54c7e0afc1a0789d0550b651de3c"
    sha256 cellar: :any_skip_relocation, mojave:         "70b715507e7d1a6daa76613ad2cd6a1fb41a54c7e0afc1a0789d0550b651de3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bab9bbfdca9d66cfcd8eff69fc79c57e136dc66a8cb95475e888ce583fd27926"
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
