class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "3652722ea98d94d8e27bf5e708dd7359f55a818a43550d046c5064c98876f1a8"
  license "PostgreSQL"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "de153e8d2ed978871f338683cc37cd3db60556efa31085b3ada30ca32a21043b"
    sha256 cellar: :any,                 arm64_big_sur:  "4b29b5814a740ba56edb6344bcb305dd50407f511394fd7714e5007caed07754"
    sha256 cellar: :any,                 monterey:       "00f830eef2cdaac50eafd420fc2e8186aa4782969d3cc80fe981acac6cd54d1c"
    sha256 cellar: :any,                 big_sur:        "569f88ebc5cad834c2b1bd0bb416cad28f315892dcfce0808f5b0cdbbaa410e3"
    sha256 cellar: :any,                 catalina:       "cf317c7daaad2d1bb6d2fff390a6d7824ef6250ba9b22c867baf4d4cc7efd0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bddc49247c16f2efa40654d060d3deb3decb171bf0cee49d54e1362219a2de2c"
  end

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
