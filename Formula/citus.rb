class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.2.0.tar.gz"
  sha256 "a23c56015b1a7fda5bef0102fce81adcf75a8ab75c4f53760795b6a64e951761"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aad932922c42a1356a40ba887dc6fdc804ad801a0fd7e2f956b409cd2b1de551"
    sha256 cellar: :any,                 arm64_monterey: "f183d84f3ca0b7b96773897f0633aa8c2a72090d32adea92d20e18cb7d512068"
    sha256 cellar: :any,                 arm64_big_sur:  "e59c1255841a7300cd3f33fcc1cce83988d4b40cc9154523f2097ce460c48094"
    sha256 cellar: :any,                 ventura:        "d8a225ffda9c90550a501d763e8524f39cda09453f9fe5350cf0f601246ff0ce"
    sha256 cellar: :any,                 monterey:       "f212362a0d98e6d84da3702c07564e78afbf48663be5fd2a2fd4198f50a53870"
    sha256 cellar: :any,                 big_sur:        "8466904ebb00b8c56e33cabf18b33da92ee8b35d8590b09eea3e7e26aa0cec03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f45f4ceb90f182bf69da5b2a7a9f5530d87f37e7d36c69a9a7577b9150f654b3"
  end

  depends_on "lz4"
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
