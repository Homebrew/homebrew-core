class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v9.2.4.tar.gz"
  sha256 "078ae6ed4b4937e143c5a6aa39bd7e6a1015806f3e16f5ad7a2aded01fbe9b4d"
  head "https://github.com/citusdata/citus.git"

  bottle do
    cellar :any
    sha256 "5f59f9bbee2214a34c757e14c0a44937e42fcd5c2b07d26a95c7bd267c05f4ce" => :catalina
    sha256 "6c8356c32797c6f445312d1fd86adece0a8219b0ab3159ce51d01280497d2f92" => :mojave
    sha256 "41fb017e63f05f1ab04f1fe99ee5533757ab66d2f15df57e87ed57c7d1debec0" => :high_sierra
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
    return if ENV["CI"]

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
