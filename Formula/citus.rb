class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.1.3.tar.gz"
  sha256 "b6169b0ab54105554c89fcfe0dfdf2a5cf1c63ad3e6779a491f8e7c1fb87737e"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "54c8d2c24ad06568d3be342a2c7c565ee2a29eae1e382d85b05830961c17c8b6"
    sha256 cellar: :any,                 arm64_big_sur:  "178712e5a612679782e562799585adb18ef8eb02d58011de4af1ee8dac737d2a"
    sha256 cellar: :any,                 monterey:       "d1e92d6c7dac45b463016d873f90690c7820a41c385441aaf3b8a3823436c78b"
    sha256 cellar: :any,                 big_sur:        "fc279b5ba45a5b96f8154453975691901054a02d661734efca918c460a0a8bd5"
    sha256 cellar: :any,                 catalina:       "462896aef04848792625f58f418be853614a02b78fbd9f21eee9cbdeee9067e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68eb9aade0243e23c2362c644fe2b35d111c4bdac97ac96f4ce86a5934424127"
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
