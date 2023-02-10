class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "45bb16481b7baab5d21dfa399b7bfa903dd334ff45a644ae81506a1ec0be0188"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "853d38ed4036f4b8b5774f769cf76e066aa65258a81b4305859b38b6ca067093"
    sha256 cellar: :any,                 arm64_monterey: "cccf4e75e3d4f1740e5a36136bcd33ad9f1b60d3c97d50ca499393c88dfbb53f"
    sha256 cellar: :any,                 arm64_big_sur:  "9501e5d48fe12c8261756a025a5bf8fc9bec784c4896cea2bbaa4425c6f68a26"
    sha256 cellar: :any,                 ventura:        "5d20cf0b06c7ac4bfbaf07db493f6d38501db677f149f01480204ec6cdef13a2"
    sha256 cellar: :any,                 monterey:       "3dfbd493ef777d2a7e5de54fd0a08073e71c979be2af54a985b09b92df401564"
    sha256 cellar: :any,                 big_sur:        "c453cfd698549808193db6742d5c429d07649c1262d2389782d1b33c66c4dc19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1764adb44cd221ccd94a63d1b590958c26d017de543ac13149d9d267353c0d8"
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
