class FlightSql < Formula
  include Language::Python::Virtualenv

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
  depends_on "libcython" => :test
  depends_on "python-packaging" => :test
  depends_on "python-setuptools" => :test
  depends_on "python@3.11" => :test

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "-S", "..", *std_cmake_args, "-G", "Ninja"
      system "cmake", "--build", ".", "--target", "install"
      bin.install "flight_sql"
    end
  end

  test do
    python3 = "python3.11"

    reqfile = testpath/"test_requirements.txt"

    reqfile.write <<~EOS
      pyarrow==15.0.0
      adbc-driver-flightsql==0.9.0
      adbc-driver-manager==0.9.0
    EOS

    ENV.append_path "PYTHONPATH", Formula["libcython"].opt_libexec/Language::Python.site_packages(python3)
    venv = virtualenv_create(testpath/"vendor", python3)
    venv.pip_install(reqfile, build_isolation: false)

    port = free_port

    runfile = testpath/"test.py"

    runfile.write <<~EOS
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
      system testpath/"vendor/bin/#{python3}", runfile
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
