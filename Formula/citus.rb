class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.0.6.tar.gz"
  sha256 "f3f2deb3e7f31844f4cc3bb0a311b52a4179cabe08c72b409819fa6f6e72f5f4"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f7f6ca6058fc3467a5b23712d4fbc39a3bd709b0a918775a91dff2ac5b162448"
    sha256 cellar: :any,                 arm64_big_sur:  "5b848a29bb3bea79c0c0ab59c06c1b779c6d842a1ce31ee5db693fcacd84dff8"
    sha256 cellar: :any,                 monterey:       "86cdd94e6cb0f364e24bea191faa0e1879a2270f8b4dd876ccbc6e66b2559d48"
    sha256 cellar: :any,                 big_sur:        "c34c4867fdd13b9da219096a614b29b6245a90b6d8d0bdbf343345091b428e58"
    sha256 cellar: :any,                 catalina:       "bb16722b2a08999b842792033a0e4f98701c565fa177f288a0b2959ec4fafb08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a469ee4c58763417ecde8b473aade4f7a34c4ce8b05b594d95b568315df1e4a"
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
