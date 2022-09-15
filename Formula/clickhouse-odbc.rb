class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://github.com/ClickHouse/clickhouse-odbc#readme"
  url "https://github.com/ClickHouse/clickhouse-odbc.git",
      tag:      "v1.1.10.20210822",
      revision: "c7aaff6860e448acee523f5f7d3ee97862fd07d2"
  license "Apache-2.0"
  revision 2
  head "https://github.com/ClickHouse/clickhouse-odbc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a3d566363b077db6801bbe9757b8199f1a946f78f526a0f66059b85bbbbfa0db"
    sha256 cellar: :any,                 arm64_big_sur:  "71de00f4651ba65f28b709262e626782a6ecbb07d795c3990fb8e518ac1b5189"
    sha256 cellar: :any,                 monterey:       "e64cccb6b7e5cf12b41e9a83def001180209af6f50f6a9d3b0eede6d63d214d0"
    sha256 cellar: :any,                 big_sur:        "35064cfb78300d168f3c5cef7852d43856922344d43a523d782c9f03cb4fa9b2"
    sha256 cellar: :any,                 catalina:       "2c2d677fc26ec5bbddfd04971926fe41a726606c560781c7f719093788231c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0da6e1c329428e002b83db225e381cb6dd0fcc6ed8fa515162f50b48a287c0f1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"

  on_macos do
    depends_on "libiodbc"
  end

  on_linux do
    depends_on "unixodbc"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    cmake_args = std_cmake_args.dup

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
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"my.odbcinst.ini").write <<~EOS
      [ODBC Drivers]
      ClickHouse ODBC Test Driver A = Installed
      ClickHouse ODBC Test Driver W = Installed

      [ClickHouse ODBC Test Driver A]
      Description = ODBC Driver for ClickHouse (ANSI)
      Driver      = #{lib/shared_library("libclickhouseodbc")}
      Setup       = #{lib/shared_library("libclickhouseodbc")}
      UsageCount  = 1

      [ClickHouse ODBC Test Driver W]
      Description = ODBC Driver for ClickHouse (Unicode)
      Driver      = #{lib/shared_library("libclickhouseodbcw")}
      Setup       = #{lib/shared_library("libclickhouseodbcw")}
      UsageCount  = 1
    EOS

    (testpath/"my.odbc.ini").write <<~EOS
      [ODBC Data Sources]
      ClickHouse ODBC Test DSN A = ClickHouse ODBC Test Driver A
      ClickHouse ODBC Test DSN W = ClickHouse ODBC Test Driver W

      [ClickHouse ODBC Test DSN A]
      Driver      = ClickHouse ODBC Test Driver A
      Description = DSN for ClickHouse ODBC Test Driver (ANSI)
      Url         = https://default:password@example.com:8443/query?database=default

      [ClickHouse ODBC Test DSN W]
      Driver      = ClickHouse ODBC Test Driver W
      Description = DSN for ClickHouse ODBC Test Driver (Unicode)
      Url         = https://default:password@example.com:8443/query?database=default
    EOS

    ENV["ODBCSYSINI"] = testpath
    ENV["ODBCINSTINI"] = "my.odbcinst.ini"
    ENV["ODBCINI"] = "#{ENV["ODBCSYSINI"]}/my.odbc.ini"

    if OS.mac?
      ENV["ODBCINSTINI"] = "#{ENV["ODBCSYSINI"]}/#{ENV["ODBCINSTINI"]}"

      assert_match "SQL>",
        pipe_output("#{Formula["libiodbc"].bin}/iodbctest 'DSN=ClickHouse ODBC Test DSN A'", "exit\n")

      assert_match "SQL>",
        pipe_output("#{Formula["libiodbc"].bin}/iodbctestw 'DSN=ClickHouse ODBC Test DSN W'", "exit\n")
    elsif OS.linux?
      assert_match "Connected!",
        pipe_output("#{Formula["unixodbc"].bin}/isql 'ClickHouse ODBC Test DSN A'", "quit\n")

      assert_match "Connected!",
        pipe_output("#{Formula["unixodbc"].bin}/iusql 'ClickHouse ODBC Test DSN W'", "quit\n")
    end
  end
end
