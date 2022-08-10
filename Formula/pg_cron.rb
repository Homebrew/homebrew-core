class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "3652722ea98d94d8e27bf5e708dd7359f55a818a43550d046c5064c98876f1a8"
  license "PostgreSQL"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f6fcd81a5ec19b8b509025cb119aad529c3cb2a903c03a9ba7f3eb8048f4ddfb"
    sha256 cellar: :any,                 arm64_big_sur:  "3cf313a14897e319e5a059b86def33f5995427121cbaabd2d51b5fde6363ad81"
    sha256 cellar: :any,                 monterey:       "c1288b4f7d7c4e3c9fd175abee7675aba64ed0095da9df3cb96ca7fe933fab74"
    sha256 cellar: :any,                 big_sur:        "2fa0fc696c015353252c0c7aaa31e4d49cee6a1ebd66c8835b7a4dbd388c200d"
    sha256 cellar: :any,                 catalina:       "085f2ddb7328743fa4d37508a8ad86031f59b07450218a32d44e2fba8e733a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3d6023e5fa0efd86869d27265a919c6d69dda937890e95c5d052f7a871dd4c8"
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
