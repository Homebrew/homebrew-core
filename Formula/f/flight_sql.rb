class FlightSql < Formula
  desc "Apache Arrow Flight SQL Server - with DuckDB and SQLite back-ends"
  homepage "https://arrow.apache.org/docs/format/FlightSql.html"
  url "https://github.com/voltrondata/flight-sql-server-example.git",
      tag:      "v1.2.5",
      revision: "242e77488a6b59c7d91b34e7d5b63f8bf97d2825"
  license "Apache-2.0"

  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gflags" => :build
  depends_on "ninja" => :build
  depends_on "openssl@3" => :build
  depends_on "python@3.12" => :build
  depends_on xcode: :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    flight_username = "brew"
    flight_password = "test"
    port = free_port
    pid = fork do
      exec bin/"flight_sql_server", "--database-filename", "/tmp/test.db", "--username",
       flight_username, "--password", flight_password, "--port", port.to_s, "--print-queries"
    end
    sleep 10
    begin
      exec bin/"flight_sql_client", "--port", port.to_s, "--username", flight_username,
       "--password", flight_password, "--command", "Execute", "--query", "SELECT 123 AS x"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
