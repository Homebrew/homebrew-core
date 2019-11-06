class CstoreFdw < Formula
  desc "Columnar store for analytics with Postgres"
  homepage "https://github.com/citusdata/cstore_fdw"
  url "https://github.com/citusdata/cstore_fdw/archive/v1.6.2.tar.gz"
  sha256 "35aabbc5a1608024e6aa038d06035e90d587e805eb706eb80652eb8547783491"

  bottle do
    cellar :any
    sha256 "a8b567b94b36717172703aaae7efdd9186c98f38019a46e5215ada8494e595ee" => :catalina
    sha256 "b6bc6b6fa4ee33cc7feb99c3048ef9111720bff5a4d9aafd46269dfe886e84a7" => :mojave
    sha256 "634bbe8703dec700f01becc6a83fce3aeb741cfcb6e3cc40527cc334b67f4bdf" => :high_sierra
    sha256 "947cd3c688305996b7b3a4159c0feab29efd5adaa0ae5548250ffdb3b8095bee" => :sierra
  end

  depends_on "postgresql"
  depends_on "protobuf-c"

  def install
    ENV["PG_CONFIG"] = Formula["postgresql"].opt_bin/"pg_config"

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
