class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.8.tar.gz"
  sha256 "c19ab9bb35406c60fb51ecda993737c083850abe424acb6c1030439d00a1f8e4"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "95211c055fab71118be825193a38433f33553a6d1b91fe48d64a8929ac532df9"
    sha256 cellar: :any, arm64_tahoe:       "f70213216b90da41859c6a8da096af2fd2934832329e13388eaed335c133682c"
    sha256 cellar: :any, arm64_sequoia:     "3a4f9fc32502da9f9841ad7a0edb813fdef369ef2a8be5504144d0521f95ea93"
    sha256 cellar: :any, arm64_sonoma:      "d17dd6d4c5579e3c32800990d4df4b6b4da12ed5b369cff465524808fb3b87f3"
    sha256 cellar: :any, arm64_linux:       "a14941b26606e49a3f69aaca137f8d59e6171a365dc4b4706ba67cf96b57974b"
    sha256 cellar: :any, x86_64_linux:      "22c919f61d6492ee31b437126078406263a7d43a26e898bf66a9cbe011f18df6"
  end

  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]
  depends_on "libpq"

  on_macos do
    depends_on "gettext" # for libintl
  end

  def postgresqls
    deps.filter_map { |f| f.to_formula if f.name.start_with?("postgresql@") }
        .sort_by(&:version)
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    # Work around for ld: Undefined symbols: _libintl_ngettext
    # Issue ref: https://github.com/citusdata/pg_cron/issues/269
    ENV["PG_LDFLAGS"] = "-lintl" if OS.mac?

    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
      # We force linkage to `libpq` to allow building for multiple `postgresql@X` formulae.
      # The major soversion is hardcoded to at least make sure compatibility version hasn't changed.
      # If it does change, then need to confirm if API/ABI change impacts running on older PostgreSQL.
      system "make", "install", "libpq=#{formula_opt_lib("libpq")/shared_library("libpq", 5)}",
                                "rpathdir=#{formula_opt_lib("libpq")}",
                                "pkglibdir=#{lib/postgresql.name}",
                                "datadir=#{share/postgresql.name}"
      system "make", "clean"
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir, "-o", "--locale=en_US.UTF-8", "-o", "'-E UTF-8'"
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'pg_cron'
        port = #{port}
        unix_socket_directories = '#{testpath}'
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-h", testpath, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_cron\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
