class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "d950bc29155f31017567e23a31d268ff672e98276c0e9d062512fb7870351f03"
  license "PostgreSQL"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "09735afcd85669a8b3c460864d987b45a85efa861b23d13d091d0a3044b9d65e"
    sha256 cellar: :any,                 arm64_sequoia: "c6248b364e481b21ca81bfc63776271f8f3eda1ed42971b88c6b1b6cf87db682"
    sha256 cellar: :any,                 arm64_sonoma:  "8f312f0971c68d69201ee2d4ed3b544c0572a4d36a2ebbc9ba8c5785ca20a556"
    sha256 cellar: :any,                 sonoma:        "8eb54aed1bdff05c61bda87a5d30ec13beed7e14539eee17f9450748f67680bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56feed3b8e5d423e83dc9218a3a17432e819b16fdd1045b7584593649fa3952d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58fc98446a6b2f23b701b53c391b8c4d052cbea137b0ea7e8fa7ff398bfe509a"
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
