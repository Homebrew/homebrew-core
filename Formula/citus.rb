class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.3.0.tar.gz"
  sha256 "e377981eda41a0c3defaafc3e7471e9f102482df70eda25dac912fcf7c24df16"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/citusdata/citus.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb2768b85bbc74fd8e5d4c5613301946efb283899aa5e5e4cee712dcd737e0b0"
    sha256 cellar: :any,                 arm64_monterey: "99b57fb7539a450df57cff81185473b752ba380848249b5fd74c18824dfe9bb1"
    sha256 cellar: :any,                 arm64_big_sur:  "f88a18a40b331102780016712ab85454993522a13f86dcd5505ac87e5e2a4824"
    sha256 cellar: :any,                 ventura:        "dfc1c08a9f84a7d7eb98e7822fd2b8c3c70c917377324779ea4bce5b3debbfb3"
    sha256 cellar: :any,                 monterey:       "af27fecd06f6d8a26d544059cf6f99ab97d648f1cf107b98e49d4fec25ef4cb5"
    sha256 cellar: :any,                 big_sur:        "91ac1faa65d40b7627782b8e26de26d718fe8534c8ce9d5a2346379c10fe2808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16ed248f6656850119e3b500d06ff0f487cf2dc563ff8114c7df151bbb8e5c34"
  end

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "postgresql@14"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "./configure"
    # workaround for https://github.com/Homebrew/legacy-homebrew/issues/49948
    system "make", "libpq=-L#{postgresql.opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    include.install (buildpath/stage_path/"include").children
    share.install (buildpath/stage_path/"share").children

    bin.install (buildpath/File.join("stage", postgresql.bin.realpath)).children
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'citus'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"citus\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
