class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v12.0.0.tar.gz"
  sha256 "9a6adaecc28e80e03a0523d07ee14c4b848f86f48ed37f84aa8cb98f3489f632"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bb1523040c2714dd707e78ae1d50a43d6527c9c1347699b860ea744a7d07b302"
    sha256 cellar: :any,                 arm64_ventura:  "f4bf486699a5729f4d0c2006001f4449f60d343256550be6017d9ba2c34ff374"
    sha256 cellar: :any,                 arm64_monterey: "eeb9601a50b0eef99e8bf5b5e7e8e8ad5dd9a2ff205e6e39a7d7a056cf9f7f89"
    sha256 cellar: :any,                 arm64_big_sur:  "e1d3d86a47cbdb1d3899f78cdfa58b11932ebdeecf77e7243ce5f87c8073b99f"
    sha256 cellar: :any,                 sonoma:         "12c5d78d573922cb565183cde30d8365543710debea30d52036d76845fc2434b"
    sha256 cellar: :any,                 ventura:        "47b61e4cc15726dac930df244271c94c96c000b8855ac360e51cbf3df0d00938"
    sha256 cellar: :any,                 monterey:       "55aedab8c64a790da451bba0e878aa04de3213b89a2399ddef69bb94cfe3e824"
    sha256 cellar: :any,                 big_sur:        "2f117d6aa7e6daaa46239f2654c3f477fa64cae2e2be6fabba91e4741210eb21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a80582e490c8d146843864627ac75b85f2fa917e671da46bd2aef9ae1676f84"
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
