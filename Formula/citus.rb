class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v8.0.0.tar.gz"
  sha256 "fe3c0b5feed9c671f0da07fbfba0e5cd494e93900348dd04863e8dd96453b8da"
  head "https://github.com/citusdata/citus.git"

  bottle do
    cellar :any
    sha256 "df0c2d5c30c9ad2024358b8a0ef480b015dc49d2f4bd55fe41c3fd6bc44bd882" => :mojave
    sha256 "d71a2f22f1ab6be4cbdb4098b92ad1d4a2c2ec231ee91e4e5ea746c27c2852a9" => :high_sierra
    sha256 "34f0d44c53db2c5f33445d9312cba78ab76eb44e5640d22c03b4af2cb15e92a5" => :sierra
    sha256 "25f491016f736b96d166b415406829533b47fcd8bbf82a0b0ef86afdd9185342" => :el_capitan
  end

  depends_on "postgresql"
  depends_on "readline"

  def install
    ENV["PG_CONFIG"] = Formula["postgresql"].opt_bin/"pg_config"

    system "./configure"

    # workaround for https://github.com/Homebrew/homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    bin.install Dir["stage/**/bin/*"]
    lib.install Dir["stage/**/lib/*"]
    include.install Dir["stage/**/include/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end

  test do
    pg_bin = Formula["postgresql"].opt_bin
    pg_port = "55561"
    system "#{pg_bin}/initdb", testpath/"test"
    pid = fork do
      exec("#{pg_bin}/postgres",
           "-D", testpath/"test",
           "-c", "shared_preload_libraries=citus",
           "-p", pg_port)
    end

    begin
      sleep 2

      count_workers_query = "SELECT COUNT(*) FROM master_get_active_worker_nodes();"

      system "#{pg_bin}/createdb", "-p", pg_port, "test"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION citus;"

      assert_equal "0", shell_output("#{pg_bin}/psql -p #{pg_port} -d test -Atc" \
                                     "'#{count_workers_query}'").strip
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
