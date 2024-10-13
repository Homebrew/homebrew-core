class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "52d1850ee7beb85a4cb7185731ef4e5a90d1de216709d8988324b0d02e76af61"
  license "PostgreSQL"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "761f569a42613c25ad934f27d9a33700bee8fae46611cf65afeb44c2e94e7490"
    sha256 cellar: :any,                 arm64_sonoma:  "37b2a1792f507b0c9056330b9692b020c051990c267796206d9a49e323e434cd"
    sha256 cellar: :any,                 arm64_ventura: "7cbf1d31f5e7b621db839a14a0769870dbb9f438b3b435bb5346976909f41974"
    sha256 cellar: :any,                 sonoma:        "0ee4c33e3afc5c2938a29a01f7e1c1796d004799c85e916a02e68caa9f75631d"
    sha256 cellar: :any,                 ventura:       "b661444235d90028484e30f5c2c5482f2ffb37c411589e2b47cc2d29f5f57361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716af477c814e3dc4fda5bbaf25b11a278b0ae93fdda8d5ebd37e1c0c12e5bb8"
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
