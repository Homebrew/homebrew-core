class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "d950bc29155f31017567e23a31d268ff672e98276c0e9d062512fb7870351f03"
  license "PostgreSQL"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "a07a1ecf77295372c7976d26dddb193d94b529d87d133386e40379e8497dff55"
    sha256 cellar: :any,                 arm64_sequoia: "903e9351b2bab78c495a3044933bf02a6407464f8afcd1c900415e95e9715d0e"
    sha256 cellar: :any,                 arm64_sonoma:  "c4eed9429951152b6fae02fc2dbf701dff9edf553eb4035f3d1cfcc2708a11f3"
    sha256 cellar: :any,                 sonoma:        "a046ebbb430f4eaa26638afcfe19082f19eaf984958d01e00650c931678d289e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e994552633f54d1d1e0a77ea71209671179bd649c65c9109564bf75e3bb035b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2a9efe94dba9e08e5a7444129f73aa88c7cb51eabf8378813f2edb18a119a8b"
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
      system "make", "install", "libpq=#{Formula["libpq"].opt_lib/shared_library("libpq", 5)}",
                                "rpathdir=#{Formula["libpq"].opt_lib}",
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
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_cron\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
