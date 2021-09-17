class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://github.com/ClickHouse/clickhouse-odbc#readme"
  url "https://github.com/ClickHouse/clickhouse-odbc.git",
    tag:      "v1.1.10.20210822",
    revision: "c7aaff6860e448acee523f5f7d3ee97862fd07d2"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-odbc.git",
    branch:   "master"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "icu4c"

  on_macos do
    depends_on "libiodbc"
  end

  on_linux do
    depends_on "unixodbc"
  end

  def install
    cmake_args = std_cmake_args.dup

    cmake_args.map! { |x| x.start_with?("-DCMAKE_BUILD_TYPE=") ? "-DCMAKE_BUILD_TYPE=RelWithDebInfo" : x }
    cmake_args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"

    cmake_args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
    cmake_args << "-DICU_ROOT=#{Formula["icu4c"].opt_prefix}"

    if OS.mac?
      cmake_args << "-DODBC_PROVIDER=iODBC"
      cmake_args << "-DODBC_DIR=#{Formula["libiodbc"].opt_prefix}"
    elsif OS.linux?
      cmake_args << "-DODBC_PROVIDER=UnixODBC"
      cmake_args << "-DODBC_DIR=#{Formula["unixodbc"].opt_prefix}"
    end

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build", "--config", "RelWithDebInfo"
    system "cmake", "--install", "build", "--config", "RelWithDebInfo"
  end

  test do
    so_suf = if OS.mac?
      "dylib"
    elsif OS.linux?
      "so"
    else
      "x"
    end

    (testpath/"my.odbcinst.ini").write <<~EOS
      [ODBC Drivers]
      ClickHouse ODBC Test Driver A = Installed
      ClickHouse ODBC Test Driver W = Installed

      [ClickHouse ODBC Test Driver A]
      Description = ODBC Driver for ClickHouse (ANSI)
      Driver      = #{lib}/libclickhouseodbc.#{so_suf}
      Setup       = #{lib}/libclickhouseodbc.#{so_suf}
      UsageCount  = 1

      [ClickHouse ODBC Test Driver W]
      Description = ODBC Driver for ClickHouse (Unicode)
      Driver      = #{lib}/libclickhouseodbcw.#{so_suf}
      Setup       = #{lib}/libclickhouseodbcw.#{so_suf}
      UsageCount  = 1
    EOS

    (testpath/"my.odbc.ini").write <<~EOS
      [ODBC Data Sources]
      ClickHouse ODBC Test DSN A = ClickHouse ODBC Test Driver A
      ClickHouse ODBC Test DSN W = ClickHouse ODBC Test Driver W

      [ClickHouse ODBC Test DSN A]
      Driver      = ClickHouse ODBC Test Driver A
      Description = DSN for ClickHouse ODBC Test Driver (ANSI)
      Url         = https://default:password@localhost:8443/query?database=default

      [ClickHouse ODBC Test DSN W]
      Driver      = ClickHouse ODBC Test Driver W
      Description = DSN for ClickHouse ODBC Test Driver (Unicode)
      Url         = https://default:password@localhost:8443/query?database=default
    EOS

    ENV["ODBCSYSINI"] = testpath
    ENV["ODBCINSTINI"] = "my.odbcinst.ini"
    ENV["ODBCINI"] = "#{ENV["ODBCSYSINI"]}/my.odbc.ini"

    if OS.mac?
      ENV["ODBCINSTINI"] = "#{ENV["ODBCSYSINI"]}/#{ENV["ODBCINSTINI"]}"
      assert_match("SQL>", `echo exit | #{Formula["libiodbc"].bin}/iodbctest "DSN=ClickHouse ODBC Test DSN A"`)
      assert_match("SQL>", `echo exit | #{Formula["libiodbc"].bin}/iodbctestw "DSN=ClickHouse ODBC Test DSN W"`)
    elsif OS.linux?
      assert_match("Connected!", `echo quit | #{Formula["unixodbc"].bin}/isql "ClickHouse ODBC Test DSN A"`)
      assert_match("Connected!", `echo quit | #{Formula["unixodbc"].bin}/iusql "ClickHouse ODBC Test DSN W"`)
    end
  end
end
