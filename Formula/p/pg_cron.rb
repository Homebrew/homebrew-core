class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "9f4eb3193733c6fa93a6591406659aac54b82c24a5d91ffaf4ec243f717d94a0"
  license "PostgreSQL"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab537999d98dd7cb8183f1dd8ac5a2a1c0b6b144e917d0088c4df624bb49d019"
    sha256 cellar: :any,                 arm64_ventura:  "81aed28f89bb77a7420e7f7ac35f3d4a461a5fbd04c9a34f72959a2b6b4d358b"
    sha256 cellar: :any,                 arm64_monterey: "89476a9d9f99446bfc07ec141f1d7b0c57e35c4e9d3f520bd094267d77994315"
    sha256 cellar: :any,                 sonoma:         "11fa040c59567059cdee5c972986770498c8eabdc5a88a99406fcf0b6ca9eb73"
    sha256 cellar: :any,                 ventura:        "5ac4c0b346031905988a1509f685c67cab56e481aef1ebe272850edff8e67966"
    sha256 cellar: :any,                 monterey:       "37c5e41876212c485e99e882e7bc9fa62d5cc968a7579691d66d434b668fb66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18e321a8163c1614a8cc93c66382525a3b71e996225001707971ebb918cbc3aa"
  end

  depends_on "postgresql@14"

  on_macos do
    depends_on "gettext" # for libintl
  end

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    # Work around for ld: Undefined symbols: _libintl_ngettext
    # Issue ref: https://github.com/citusdata/pg_cron/issues/269
    ENV["PG_LDFLAGS"] = "-lintl" if OS.mac?

    system "make", "install", "PG_CONFIG=#{postgresql.opt_bin}/pg_config",
                              "pkglibdir=#{lib/postgresql.name}",
                              "datadir=#{share/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
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
