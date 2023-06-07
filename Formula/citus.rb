class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.3.0.tar.gz"
  sha256 "e377981eda41a0c3defaafc3e7471e9f102482df70eda25dac912fcf7c24df16"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "398549449b04a28c1302605dd4621b5493b258972eb1d5f16a8bdce6ecff1436"
    sha256 cellar: :any,                 arm64_monterey: "fbb309c3fde5c222885c7d007a83110eef1960b68d254c0e198461f2a062e768"
    sha256 cellar: :any,                 arm64_big_sur:  "351424c803b9b8a5d62d66ce6a9d4fb95086480fde4371626be0341b672c4d34"
    sha256 cellar: :any,                 ventura:        "470eeb16f8cbc805f227a48fc99b38eb63c07297b56a43dac3ae3d723c1cf71d"
    sha256 cellar: :any,                 monterey:       "dcf27b85c3827edfb59329b8a8e6cd83f86eba2499cc2a9a8dc68cef85c0bab3"
    sha256 cellar: :any,                 big_sur:        "154a86d90a01ca12df25b98f01db3665e857356894e4b8078d0cc05a2399055c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "472c0b3636fd438fe56dd77b29786dc3a3c1a8a505ccfccd392e2090e4d7ffb3"
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
