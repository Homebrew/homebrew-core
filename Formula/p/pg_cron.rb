class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "52d1850ee7beb85a4cb7185731ef4e5a90d1de216709d8988324b0d02e76af61"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4000e880882f55b3d67500e5af3136ec503352ec0ff5149820ddf7c2a956ed3"
    sha256 cellar: :any,                 arm64_ventura:  "a4c5ceb4fd4dc0f48b2467a973c9da39c035310ccd9f9e7b33a292946af1a8c9"
    sha256 cellar: :any,                 arm64_monterey: "bf81b4a0c65c288a78144458945bfb43f9b4b6ec58f91a95534fa226b85125d4"
    sha256 cellar: :any,                 sonoma:         "9c26f60cc911b2dbff41be7fa52bab1169d0196f76a02ff5189f06a2424b1ae9"
    sha256 cellar: :any,                 ventura:        "24ea0207cb01a894dde9759e16cbc251f0c208a116a954a1db3a34aab5c36acf"
    sha256 cellar: :any,                 monterey:       "ccf9d396b36b9f7273ed532f9cf7b7ff397c16dadac70ba6466dba564240ca80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6fe3792c2ab79fc559a08b92f858d6ba3cab54073a2861c3a5eb5ea81013df1"
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
