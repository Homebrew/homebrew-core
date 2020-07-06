class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v9.3.2.tar.gz"
  sha256 "2455135d9186140363530f160a9d6bebabec36273efd7c2fab9f824387f8625f"
  license "AGPL-3.0"
  head "https://github.com/citusdata/citus.git"

  bottle do
    cellar :any
    sha256 "8bd267b5e781d6bedb24ced94d6f420f8ea712698813a30619afa8f1288937e7" => :catalina
    sha256 "e2ae5075f1b400a6e57997e0e2087635ad3de13a353d30550d5d59389bf19d4b" => :mojave
    sha256 "fb6eb7fb42077c25885a165f9ab978d24ea12b4a429f13a776fa11984df31c00" => :high_sierra
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
