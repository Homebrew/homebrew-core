class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v5.2.1.tar.gz"
  sha256 "5014839eb7f20b1bd338e482340faedbd8162979992a6475d5dfea516dd0657c"
  revision 1

  head "https://github.com/citusdata/citus.git"

  bottle do
    sha256 "b51d4a8560ce4c8b26d83071e79ec8399ca6856bd9b5b30ff9bd422a2b4398dc" => :sierra
    sha256 "3340925d455fafcc9f1f03a22649d2733f992c1409b3ac2e238f1b0e1991d687" => :el_capitan
    sha256 "2b40b992fdff0c717c738df980ad4e267dd4615848e0092b4d8ae15c47c19433" => :yosemite
    sha256 "f9f3a96b4cd30c6d47995e306f18775e1324094ae0c74c99273fd6d3a36b5c53" => :mavericks
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
