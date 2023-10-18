class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "7e5ec9a519b8f7c5a2b350153093c7b87ff7d94aef2ed461a5844e4313aadf07"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5571e9ac1e68d7499478fe6ed3e10bbab5f4fb0028347f287069643270fca2dc"
    sha256 cellar: :any,                 arm64_ventura:  "773177d9e4572507103e317feddee472943fb8ab16ed9efc53d3858cf6d72ad7"
    sha256 cellar: :any,                 arm64_monterey: "5c459350d01db22c58ddfa9028fa86e8fbf1ff1b5f3f231b4571cc8714b32667"
    sha256 cellar: :any,                 sonoma:         "afe71323fdeb10ae760c0720ab9b3c0e071ca70fbe20cf28bab17cdd9b4615f9"
    sha256 cellar: :any,                 ventura:        "9fd69e080d04d2c9556e8a8e11340267d04873481a4c62e06eaea2c4ee22a0ff"
    sha256 cellar: :any,                 monterey:       "197f7fac1541f6e6e521e2a9c9bba3ff5a5a27d52c6b44a2b3c1224e3862a6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4ca4ded99eac1f0c194cd313806d66e0fe884e6e97f60ab95b813b6d73b2dc5"
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
