class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://github.com/ClickHouse/clickhouse-odbc#readme"
  url "https://github.com/ClickHouse/clickhouse-odbc.git",
      tag:      "v1.1.10.20210822",
      revision: "c7aaff6860e448acee523f5f7d3ee97862fd07d2"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ClickHouse/clickhouse-odbc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "420b61266c61a96400fbee24dcfcd3b76b7291bfdce3133d50f118e0d63b9fab"
    sha256 cellar: :any,                 arm64_big_sur:  "864770fdac3047d862830b7afacb45d17fbb420ab63cd00d27503862ef1a4f1c"
    sha256 cellar: :any,                 monterey:       "71073b86f8b363aad6c733d75c3d389accb32e559a32decbab10c0a444f02ad0"
    sha256 cellar: :any,                 big_sur:        "ed0402d5455e56d88a896e786754d013f3165d585cdb42e7e9dd5da8c5d4fd33"
    sha256 cellar: :any,                 catalina:       "4bb619896ce647d4cc6171bf0f0dc76bcdfc5e2a264146d8ab9236b49714ec50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1a2917e04ffa2ba091586adc930345d437f29ca390424e6b5305cdb8298169"
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
    depends_on "gcc"
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
