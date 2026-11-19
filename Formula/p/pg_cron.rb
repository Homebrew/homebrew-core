class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.8.tar.gz"
  sha256 "c19ab9bb35406c60fb51ecda993737c083850abe424acb6c1030439d00a1f8e4"
  license "PostgreSQL"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3e83853bf9ee22e7c27fcc9d3813e2b97b47984a94452d745224f10c3a8ce5c5"
    sha256 cellar: :any, arm64_tahoe:       "2721a0e6777877ad7dedba04e3e37bf789b42194ed0258f74c48eb2136e62b33"
    sha256 cellar: :any, arm64_sequoia:     "b24e95b802f4cedaa19ad93a6b2ef678246780bda14abc3de6f7569a6671eeb9"
    sha256 cellar: :any, arm64_linux:       "264ee471ce52121ffef86923c95c2fdb17638db6ffd0e22b726b27120ee925f5"
    sha256 cellar: :any, x86_64_linux:      "70030df1da202a4ee0f376fed9d29cabc324a242aacc59f6f23b1f80598fe53d"
  end

  depends_on "postgresql@18" => [:build, :test]
  depends_on "postgresql@19" => [:build, :test]
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
