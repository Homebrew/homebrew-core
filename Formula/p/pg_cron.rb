class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "0118080f995fec67e25e58d44c66953e7b2bf5a47bb0602fd2ad147ea646d808"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e652baea4a5497dccbe7a785953c08f43e820712efee0c47b7ea4299645888dd"
    sha256 cellar: :any,                 arm64_sonoma:  "5d5ef653d695a0e1029f119532988583d01b18b1bcd0996d7c79f344912bf870"
    sha256 cellar: :any,                 arm64_ventura: "8617379afc5a21586ac1558c3320d82aaddb8078382fe51e7eb034c2d1772cfa"
    sha256 cellar: :any,                 sonoma:        "5160bb9284524342df8e0c8140d5715b420c26cf3ff874a9d6462530313c6adf"
    sha256 cellar: :any,                 ventura:       "44132449e3e3733f9d7342a5e12c23d571402bea3bb7074a23b197b605fca091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8babbb9f6137aded2381013aadc7f8a238163910e7c8a6b32d12cd689ef36d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45b413c1332572e44d2e73a04f0d90a932bb34ad1ac7aee78541f9176ecf7b65"
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
