class CstoreFdw < Formula
  desc "Columnar store for analytics with Postgres"
  homepage "https://github.com/citusdata/cstore_fdw"
  url "https://github.com/citusdata/cstore_fdw/archive/v1.6.2.tar.gz"
  sha256 "35aabbc5a1608024e6aa038d06035e90d587e805eb706eb80652eb8547783491"
  revision 1

  bottle do
    cellar :any
    sha256 "d6b1fd16c930e9296175924104500bbb277780fa432a6c798ca08550038e5d67" => :catalina
    sha256 "da634eeeaef15ef6f5820a5d5b0c9fc9cb9267d575d3ec95a60f86d94112b9da" => :mojave
    sha256 "76c6867e57fdaf5be3b0841d833602c222280642255238a3fd65c7aa24c0e4a5" => :high_sierra
  end

  depends_on "postgresql"
  depends_on "protobuf-c"

  # PostgreSQL 12 compatibility patches
  patch do
    url "https://github.com/citusdata/cstore_fdw/commit/db6cc99f23d1a4f4eacead60521bd49c0ba3352d.patch?full_index=1"
    sha256 "2159967206a4604c382e7dbd66f2ddb3ca0a5ae954620c85d5842e2eebffa086"
  end

  patch do
    url "https://github.com/citusdata/cstore_fdw/commit/4497b13baed58e2d8d97f0b840579b4503956226.patch?full_index=1"
    sha256 "89a7aa514741c3a647aafb287b6ddf26625f28421951e70f8d1d74e5fdec3c79"
  end

  def install
    # workaround for https://github.com/Homebrew/homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end

  test do
    pg_bin = Formula["postgresql"].opt_bin
    pg_port = "55561"
    system "#{pg_bin}/initdb", testpath/"test"
    pid = fork do
      exec("#{pg_bin}/postgres",
           "-D", testpath/"test",
           "-c", "shared_preload_libraries=cstore_fdw",
           "-p", pg_port)
    end

    begin
      sleep 2

      cmds = ["CREATE EXTENSION cstore_fdw;",
              "CREATE SERVER cstore_server FOREIGN data WRAPPER cstore_fdw;",
              "CREATE FOREIGN TABLE T(x int) SERVER cstore_server OPTIONS(compression 'pglz');",
              "INSERT INTO T(x) SELECT 42;"]

      system "#{pg_bin}/createdb", "-p", pg_port, "test"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[0]
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[1]
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[2]
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[3]

      assert_equal "42", shell_output("#{pg_bin}/psql -p #{pg_port} -d test -AXtc" \
                                      "'SELECT x from T;'").strip
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
