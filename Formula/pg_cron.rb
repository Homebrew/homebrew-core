class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "45bb16481b7baab5d21dfa399b7bfa903dd334ff45a644ae81506a1ec0be0188"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "477d1eb67829094fc7f1e1841fe2879ff95587dea1ac17ed1cb398309eecf9ae"
    sha256 cellar: :any,                 arm64_monterey: "218080009065e590c595a968ac2b8641716d774d8b9934672b6450bfad266cdc"
    sha256 cellar: :any,                 arm64_big_sur:  "adacd84a0112f425fe134f993015b966b5c885a4a19fb027abb54dbb2afa30a2"
    sha256 cellar: :any,                 ventura:        "ddf4f67386f09b337c11901e8c011d5df7c49e4cdb377516074f38c89ed7a1db"
    sha256 cellar: :any,                 monterey:       "991c2b4912755af9c26d111f877a08c582798eec7639ec33093b15f2e30efcc6"
    sha256 cellar: :any,                 big_sur:        "0b1a303c762614d38f7f0e476b9911029e6d9b42d6805e8684d2dd4bcfe1d27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4b9b14a120a6e4df296b7903fafad5b69218d0115c34d77ae5f62e2e87c42a9"
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
