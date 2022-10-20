class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://github.com/ClickHouse/clickhouse-odbc#readme"
  url "https://github.com/ClickHouse/clickhouse-odbc.git",
      tag:      "v1.2.1.20220905",
      revision: "fab6efc57d671155c3a386f49884666b2a02c7b7"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-odbc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dd7b94675b99b5f14c9a8b0dd369ce762351a6537994de18f292173c24fa048f"
    sha256 cellar: :any,                 arm64_big_sur:  "62236c6e9f34f979806f24823aa2bf35a78c0f623581c1be06f6b5a05e39c395"
    sha256 cellar: :any,                 monterey:       "fe74d8770d3b89a787b09d154d7f475bd55515446a4c46305e1b2c0dbda966f7"
    sha256 cellar: :any,                 big_sur:        "f868c7522477129ebf0449767a960b597a4001ecd20372cb899c5316c81593d0"
    sha256 cellar: :any,                 catalina:       "228859e9777f465e7c11d5c1e78a1c7c040d0cad018f2f09a18aee10bf151b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d9ad01627d29abf95309c3a1e142f8cd9835311f422820b7b6d0a1610433900"
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
