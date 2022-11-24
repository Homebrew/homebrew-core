class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.1.4.tar.gz"
  sha256 "7c60de176c02c7082716c0c98d7084f0d4e0bef7862a53487411ee0e5622ab2c"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8463888de4ced29c89328b4d2b6f9c884ba63e5e940e15ad33515fbebd4d15a8"
    sha256 cellar: :any,                 arm64_monterey: "f37360c3a53ba771527889b30cf374fb1a1a2d7843b6170a4033639bfcadd609"
    sha256 cellar: :any,                 arm64_big_sur:  "3fa5cbfcfa015284ccf9e8b2f41b0c772abac4085ddff1e8c30a670d60ab2dfb"
    sha256 cellar: :any,                 ventura:        "62f159bd9bfc9f80f3c08ef2c7f210cec2ce2437af43954258e8780c819440f7"
    sha256 cellar: :any,                 monterey:       "9f96a4093f7567b3eee91f285b438da3c1d66d0f8cec24ae77e09e18e444c9dc"
    sha256 cellar: :any,                 big_sur:        "963d98999189f952d5a024e409d5132519776b324d1af2aaa2325cd3b9e8e891"
    sha256 cellar: :any,                 catalina:       "c05d2ec56cfc657dbf61338c23dcd5c2344f96371acdb57ff9d678eea483041a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7115a0eb7db6e4d8398a76cb73bc1483a4b9b94512019e164c8f7805bc2f33c"
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
