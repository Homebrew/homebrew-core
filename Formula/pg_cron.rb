class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "6f7f0980c03f1e2a6a747060e67bf4a303ca2a50e941e2c19daeed2b44dec744"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1354aab62f348135f3eb3f958501713abfd4f55f7b0d31d5f9be7f3f8b957b0"
    sha256 cellar: :any,                 arm64_monterey: "f1966148855d0c61e57332da132ae076891d1a209fe0c375c7fcc3a267db7139"
    sha256 cellar: :any,                 arm64_big_sur:  "b2fc6d147b890e786eca05560d8e2757a19e2606c628b8e21a1f826dd14d2132"
    sha256 cellar: :any,                 ventura:        "facab61695bb48936085eee1905431a60473ec5d9b1626166ad5f7cc52b3984f"
    sha256 cellar: :any,                 monterey:       "80743a74bb21f30bcfe98dd62e720f5a8dffca8978d6c376051b7732448758c7"
    sha256 cellar: :any,                 big_sur:        "904da5e3e39d239c4f70e56b6823fae21c44e89a8c0b54ea25201b0e9742ea00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a84b6f00593314a8d52e9d4cb6c8dce0442e0d7f67a622e040f0a9538924a914"
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
