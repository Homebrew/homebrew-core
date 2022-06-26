class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "f50792baa7105f7e5526ec0dca6d2328e4290131247c305cc84628cd864e9da2"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "452717efa283a376af04242f171f70e95db5e979361bec2333731ead63270915"
    sha256 cellar: :any,                 arm64_big_sur:  "a553ff5599e3ab016756afcb2d491e290b965827b91bf5b41faf8b6f078b2a89"
    sha256 cellar: :any,                 monterey:       "059a8d12d77a7f507375fad1187f5250a1d00272f1717e7efb77a8f275870c15"
    sha256 cellar: :any,                 big_sur:        "0e5d2f3a3dd63b1acd63ce8b45e0ea74d93de2301484f95a2ccbaaccb2031667"
    sha256 cellar: :any,                 catalina:       "2e3c48832f5ac05cbc92da3b88a1efe63e0c96566ec376dfbf7210d2a71722e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc25bcb760e06c8a241ee36b83513b200b96be03b8550d2d1fb325541bc37dd9"
  end

  depends_on "postgresql"

  def install
    system "make"
    (lib/"postgresql").install "pg_cron.so"
    (share/"postgresql/extension").install Dir["pg_cron--*.sql"]
    (share/"postgresql/extension").install "pg_cron.control"
  end

  test do
    # Testing steps:
    # - create new temporary postgres database
    system "pg_ctl", "initdb", "-D", testpath/"test"

    port = free_port
    # - enable pg_cron in temporary database
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_cron'
      port = #{port}
    EOS

    # - restart temporary postgres
    system "pg_ctl", "start", "-D", testpath/"test", "-l", testpath/"log"

    # - run "CREATE EXTENSION pg_cron;" in temp database
    system "psql", "-p", port.to_s, "-c", "CREATE EXTENSION pg_cron;", "postgres"

    # - shutdown temp postgres
    system "pg_ctl", "stop", "-D", testpath/"test"
  end
end
