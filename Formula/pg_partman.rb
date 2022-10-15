class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v4.7.1.tar.gz"
  sha256 "185821d4fbe2d966b6558203748c3479dcf51e9e19670ba5886844be11a3dc00"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bda61839005e90abb9a1252cd2513799383e3adb774671f4f7a344779fb6e1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfaa66325cabcf164e540c429cea58f53156fcdcb7e86c025d9efe027c7bb4c0"
    sha256 cellar: :any_skip_relocation, monterey:       "3bea059b38d700b7aba3f581a5c6ce4869038f52e517e1f8af19721206f90579"
    sha256 cellar: :any_skip_relocation, big_sur:        "af1176ae5df7c0a65f6552400adf8237009454976bb5ef1914841f3b219a9321"
    sha256 cellar: :any_skip_relocation, catalina:       "b5831b399ae0dd0f64d6e1958968f4215a4524b8d844ee6d00aeda4aac31d898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c33bb4b71f821d6868a467ca7cd057c5fd7507e45851889470f91b318a002d2e"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    (lib/postgresql.name).install "src/pg_partman_bgw.so"
    (share/postgresql.name/"extension").install "pg_partman.control"
    (share/postgresql.name/"extension").install Dir["sql/pg_partman--*.sql"]
    (share/postgresql.name/"extension").install Dir["updates/pg_partman--*.sql"]
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_partman_bgw'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_partman\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
