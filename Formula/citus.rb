class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v9.3.5.tar.gz"
  sha256 "d6ac87d3494b51fb31e9a0b7cc890a7a6ffa2dcf786a111bd3a68677fe24109d"
  license "AGPL-3.0"
  head "https://github.com/citusdata/citus.git"

  bottle do
    cellar :any
    sha256 "bb9cb13e4d8661d4ae98d36c862be76cc953e7893f554892877227a06859a032" => :catalina
    sha256 "7119f88d563d76283f7e0855d89b92078c5bb1a3541583ceca1d26dd321e57aa" => :mojave
    sha256 "31fbbb96ca5a9e56d49999c19d3f2b9f2b25e7be62f8138c831dae75effc2aea" => :high_sierra
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
