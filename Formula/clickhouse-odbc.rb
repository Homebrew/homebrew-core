class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://github.com/ClickHouse/clickhouse-odbc#readme"
  url "https://github.com/ClickHouse/clickhouse-odbc.git",
      tag:      "v1.2.1.20220905",
      revision: "fab6efc57d671155c3a386f49884666b2a02c7b7"
  license "Apache-2.0"
  revision 2
  head "https://github.com/ClickHouse/clickhouse-odbc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "646ee4f8ebc0df78b212c1ee74bd7a74ca2328ff015d30e768e696bac69ad7e2"
    sha256 cellar: :any,                 arm64_monterey: "12bbf5b2cfff9719b1b152fbaaeade5402dd00e3c1afdce26fe1038d816e62f8"
    sha256 cellar: :any,                 arm64_big_sur:  "f2f916066c47b770a833c6f57fe454fed0651404a3d7d661fca046b0d144e95d"
    sha256 cellar: :any,                 ventura:        "189a8c47018d91004450d3126eaa9b6b2d04916f6c7e98688481fef460213e36"
    sha256 cellar: :any,                 monterey:       "c74cd3c21681d3ef719f093a0906b992c7f84f5da72a77e81875f97111f06a50"
    sha256 cellar: :any,                 big_sur:        "5d9076057b916ff473394f93ba6508e5c16e9b21a9b1925466192de0f1e9f94a"
    sha256 cellar: :any,                 catalina:       "340093f17757dc9016aea7083da93c1fbe5f51bfcb44978c3906519334951b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64ef6e9358d4954126c39b069cf88a02d1164f674bd0aca7b62a0a2b49cc9018"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@3"
  depends_on "poco"

  on_macos do
    depends_on "libiodbc"
  end

  on_linux do
    depends_on "unixodbc"
  end

  fails_with :gcc do
    version "6"
  end

  def install
    # Remove bundled libraries excluding required bundled `folly` headers
    %w[googletest nanodbc poco ssl].each { |l| (buildpath/"contrib"/l).rmtree }

    args = %W[
      -DCH_ODBC_PREFER_BUNDLED_THIRD_PARTIES=OFF
      -DCH_ODBC_THIRD_PARTY_LINK_STATIC=OFF
      -DICU_ROOT=#{Formula["icu4c"].opt_prefix}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
    ]
    args += if OS.mac?
      ["-DODBC_PROVIDER=iODBC", "-DODBC_DIR=#{Formula["libiodbc"].opt_prefix}"]
    else
      ["-DODBC_PROVIDER=UnixODBC", "-DODBC_DIR=#{Formula["unixodbc"].opt_prefix}"]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
