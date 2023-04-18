class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.2.0.tar.gz"
  sha256 "a23c56015b1a7fda5bef0102fce81adcf75a8ab75c4f53760795b6a64e951761"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5513dec9025a5251d05e6833f1ef9f1f4d12f08410787329b6a9f757f17614f"
    sha256 cellar: :any,                 arm64_monterey: "9c557142733e8d74a33dacab76e70600b1103ae15a1da58b7e64147b5b951251"
    sha256 cellar: :any,                 arm64_big_sur:  "8b3697d74f275a8415a42b4ab433794e9dbebfb11873140bd63ecb268d528a43"
    sha256 cellar: :any,                 ventura:        "f254a0096cf6377de7e9232f98feab0aa39924431d5d31254c3ec1fca35db1de"
    sha256 cellar: :any,                 monterey:       "26fc1f56f8b4cbaf45dcd07a22547989185671624cb40b331e8384ab7bb2a60e"
    sha256 cellar: :any,                 big_sur:        "96b7d4bb2159ce738f33ea52d237eb83474b99f87806646d77d72f3dfb399c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c3bf3ac620d327f57c2fb811916240a97b28c7c76142e71b0e94670f9a1c494"
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
