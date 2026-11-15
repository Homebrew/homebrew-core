class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://clickhouse.com"
  license "Apache-2.0"
  revision 2
  head "https://github.com/ClickHouse/clickhouse-odbc.git", branch: "master"

  stable do
    # Git modules are all for bundled libraries so can use tarball without them
    url "https://github.com/ClickHouse/clickhouse-odbc/archive/refs/tags/v1.5.5.20260810.tar.gz"
    sha256 "a954c7630d9a4af6c5c68798b72710aa2297e5dbb8c4339cdf10a4ba88d092a6"

    # TODO: Consider adding formula for https://github.com/nanodbc/nanodbc
    resource "nanodbc" do
      url "https://github.com/ClickHouse/nanodbc/archive/69a9376d033e1fcf483a08e2feb9f09399cf56b6.tar.gz"
      version "69a9376d033e1fcf483a08e2feb9f09399cf56b6"
      sha256 "898ecf9bb614d6275e29266960811c1642946cece1f79e50643fa8022789bf89"

      livecheck do
        url "https://api.github.com/repos/ClickHouse/clickhouse-odbc/contents/contrib/nanodbc?ref=v#{LATEST_VERSION}"
        strategy :json do |json|
          json["sha"]
        end
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ee1d2d878c93126733f2f9425a66e17277b4bd31efcd97c36b8bece2c83d7609"
    sha256 cellar: :any, arm64_tahoe:       "da15332d079fba7b0f876608029a9b4cf9f966cb185b4e98e2bd1c3fd818c5e3"
    sha256 cellar: :any, arm64_sequoia:     "1a1fa9c852905cd6589305006ada854d4c19703baa83be6623c7fd55f84b829c"
    sha256 cellar: :any, arm64_linux:       "e5f769296a16aba4d9a088599460d2276558be534fcfee3dfc838f3d1485c1c2"
    sha256 cellar: :any, x86_64_linux:      "f6c4925130452e292555f886df0bae09d6c6f6d75c157a6737b49edd2a6e76a4"
  end

  depends_on "cmake" => :build
  depends_on "folly" => :build
  depends_on "icu4c@79"
  depends_on "openssl@4"
  depends_on "poco"
  depends_on "unixodbc"

  deny_network_access!

  def install
    resource("nanodbc").stage("contrib/nanodbc")

    # Avoid trying to build LLVM libc++ and libunwind
    inreplace "cmake/linux/default_libs.cmake" do |s|
      s.gsub! "include (cmake/cxx.cmake)", ""
      s.gsub! "include (cmake/unwind.cmake)", ""
    end

    # Unbundle dependencies
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "add_subdirectory(contrib/poco)", ""
      s.gsub! "add_subdirectory (contrib EXCLUDE_FROM_ALL)", <<~CMAKE
        find_package(ICU REQUIRED COMPONENTS i18n uc data)
        add_library(_icu INTERFACE)
        target_link_libraries(_icu INTERFACE ICU::i18n ICU::uc ICU::data)
        add_library(ch_contrib::icu ALIAS _icu)

        find_package(ODBC REQUIRED)
        add_library(ch_contrib::unixodbc ALIAS ODBC::Driver)

        find_package(Poco REQUIRED Net NetSSL Util)
        add_library(Poco::Net::SSL ALIAS Poco::NetSSL)

        \\0
      CMAKE
    end

    args = %w[
      -DCH_ODBC_PREFER_BUNDLED_THIRD_PARTIES=OFF
      -DCH_ODBC_THIRD_PARTY_LINK_STATIC=OFF
      -DODBC_PROVIDER=UnixODBC
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"my.odbcinst.ini").write <<~INI
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
    INI

    (testpath/"my.odbc.ini").write <<~INI
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
    INI

    ENV["ODBCSYSINI"] = testpath
    ENV["ODBCINSTINI"] = "my.odbcinst.ini"
    ENV["ODBCINI"] = "#{ENV["ODBCSYSINI"]}/my.odbc.ini"

    assert_match "Connected!",
      pipe_output("#{formula_opt_bin("unixodbc")}/isql 'ClickHouse ODBC Test DSN A'", "quit\n")

    assert_match "Connected!",
      pipe_output("#{formula_opt_bin("unixodbc")}/iusql 'ClickHouse ODBC Test DSN W'", "quit\n")
  end
end
