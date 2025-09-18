class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "d950bc29155f31017567e23a31d268ff672e98276c0e9d062512fb7870351f03"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db8a7bfe281044697f5f7b0835b95052e1ed0fb3688c673b6d65efbf1f047d78"
    sha256 cellar: :any,                 arm64_sequoia: "937e5bc2845b6ccf62c19823c03b39678ece0efd0c2834d81aa56795b0ba7199"
    sha256 cellar: :any,                 arm64_sonoma:  "a14743988807d045690aa9cfbc58d58b2f2f431e1951ddfa41547a55296043e8"
    sha256 cellar: :any,                 arm64_ventura: "8de0b4c5f4177977f2de2db6ab5fb3047d38d4233836b98a5ade1a45427436ef"
    sha256 cellar: :any,                 sonoma:        "9fd83573a717b2ccdc615bf0dc196be9ebb33c3f4a614e3fcdfda0bf8503341f"
    sha256 cellar: :any,                 ventura:       "6e2af376fd0565ccff721ae6cb9f3f7e399c78e494b18008ef2291927cc6dd1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66babf31f827196051d5f074ccaa9538d26c361908b4a9037a29ce39d657cdc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7206a1fa1242bbed6b486da83c12b373da497bf3ccaa72d81ba0d0dd6db55b5"
  end

  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]
  depends_on "libpq"

  on_macos do
    depends_on "gettext" # for libintl
  end

  def postgresqls
    deps.filter_map { |f| f.to_formula if f.name.start_with?("postgresql@") }
        .sort_by(&:version)
  end

  def install
    # Work around for ld: Undefined symbols: _libintl_ngettext
    # Issue ref: https://github.com/citusdata/pg_cron/issues/269
    ENV["PG_LDFLAGS"] = "-lintl" if OS.mac?

    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
      # We force linkage to `libpq` to allow building for multiple `postgresql@X` formulae.
      # The major soversion is hardcoded to at least make sure compatibility version hasn't changed.
      # If it does change, then need to confirm if API/ABI change impacts running on older PostgreSQL.
      system "make", "install", "libpq=#{Formula["libpq"].opt_lib/shared_library("libpq", 5)}",
                                "pkglibdir=#{lib/postgresql.name}",
                                "datadir=#{share/postgresql.name}"
      system "make", "clean"
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
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
