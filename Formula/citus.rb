class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.1.3.tar.gz"
  sha256 "b6169b0ab54105554c89fcfe0dfdf2a5cf1c63ad3e6779a491f8e7c1fb87737e"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d56c3a27c30a0ede04a23a4053eb5ee63d8cfa15575703ed77a4698e75251e0"
    sha256 cellar: :any,                 arm64_big_sur:  "fa8ddb014abb0a33dad223c58c376490ff06d044be004c70df75b52f99f540f3"
    sha256 cellar: :any,                 monterey:       "87d1857d968302985357769c6bf2daf8f9b5ed803be1846582891fbe83bf9a8f"
    sha256 cellar: :any,                 big_sur:        "83d71839e33e4d298346e2e63bdcd45eda22549a19c7f8c48c40e666e19576df"
    sha256 cellar: :any,                 catalina:       "f0284fb035618e9a4728c96885506318284c9a0809e739381855cfc9edf514f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c0d72c59e1a250597d31751cb30de4354deb3c7ebdf9ef9f977cf675f9f66ff"
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
