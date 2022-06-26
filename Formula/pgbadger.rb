class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://pgbadger.darold.net/"
  url "https://github.com/darold/pgbadger/archive/v11.8.tar.gz"
  sha256 "ddf4714ac058e0170359af43c22addcc0872ae17ba6f15c4e3c5a71be3b68291"
  license "PostgreSQL"
  head "https://github.com/darold/pgbadger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14c6be30fcb494f156c9e06700f1930a5ec306b9be715e647afaa2319138132c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc2767affa21e941a91b14ddb5622027af8383b33c739969cae9e2896725215d"
    sha256 cellar: :any_skip_relocation, monterey:       "94fe00a37abe83df467c20fb60cfadc7140dfdb7ad5de9d06f6d0de70449fe85"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec7c5490b66889b7dfa965f6b845b7c3ca19a94100d3bb15a6bf6602a20ea3d2"
    sha256 cellar: :any_skip_relocation, catalina:       "9a0cd6664145e98e6d291f37ac262ae8c6e4820c5b5627e42f09630ec09d1b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5192e1ac9ad093144950218397106a35b7dec3aa3e18d887234d391cb4026537"
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
