class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "383a627867d730222c272bfd25cd5e151c578d73f696d32910c7db8c665cc7db"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f811a5d1797e7ebde363aa65b2fcc16cbdba160a6e4a90c08a9651d3a9bd06a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d04d16a202c767536dc3854418ff5c69fdbd20baffe7ae2d8d596fd04cab7f9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "762c93e33e1d94f2013e92db692921935f405cdf24e7987552011567988c15e2"
    sha256 cellar: :any_skip_relocation, ventura:        "7e2731391c07e10d9388b8aaa0e82bc243ae56637dcd64c70d60a39a9d6dcc4f"
    sha256 cellar: :any_skip_relocation, monterey:       "b794504c34f59541c9b43c7f93b28f388e456bd3fdd62fecbc3ff3faa9af77c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e4d4c4a75ef147f2d26d31c25f0d698cfd2b299e07a3971a230adb318282b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a594de01858cd014b8c7ff3fc81c34b0a2048066aeba4b6909d1a2c59c910e00"
  end

  # upstream issue for running with pg@15, https://github.com/citusdata/pg_cron/issues/237
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    (lib/postgresql.name).install "pg_cron.so"
    (share/postgresql.name/"extension").install Dir["pg_cron--*.sql"]
    (share/postgresql.name/"extension").install "pg_cron.control"
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_cron'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_cron\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
