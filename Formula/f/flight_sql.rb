class FlightSql < Formula
  desc "Apache Arrow Flight SQL Server - with DuckDB and SQLite back-ends"
  homepage "https://arrow.apache.org/docs/format/FlightSql.html"
  url "https://github.com/voltrondata/flight-sql-server-example.git",
      tag:      "v1.1.19",
      revision: "96f9831a901c4660c9cfb6cf299a682ef9614bb2"
  license "Apache-2.0"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "openssl@3" => :build
  depends_on xcode: :build
  depends_on "python@3.11" => :test

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "-S", "..", *std_cmake_args, "-G", "Ninja"
      system "cmake", "--build", ".", "--target", "install"
      bin.install "flight_sql"
    end
  end

  test do
    port = free_port
    (testpath/"test_requirements.txt").write <<~EOS
      pyarrow==15.0.0
      adbc-driver-flightsql==0.9.0
      adbc-driver-manager==0.9.0
    EOS
    (testpath/"test.py").write <<~EOS
      from adbc_driver_flightsql import dbapi as flight_sql
      with flight_sql.connect(uri="grpc://localhost:#{port}",
                              db_kwargs={"username": "flight_username",
                                         "password": "test"
                                        }
                             ) as conn:
          with conn.cursor() as cur:
              cur.execute("SELECT 123 AS x")
              x = cur.fetch_arrow_table()
              print(x)
    EOS
    pid = fork { exec bin/"flight_sql", "-D", "/tmp/test.db", "-P", "test", "-R", port.to_s, "-Q" }
    sleep 10
    begin
      pythons.each do |python|
        python_exe = python.opt_libexec/"bin/python"
        system python_exe, "-m", "pip", "install", *std_pip_args, "--requirement", "test_requirements.txt"
        system python_exe, "test.py"
      end
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
