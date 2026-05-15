class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://github.com/ClickHouse/clickhouse-odbc"
  license "Apache-2.0"
  revision 2
  head "https://github.com/ClickHouse/clickhouse-odbc.git", branch: "master"

  stable do
    # Git modules are all for bundled libraries so can use tarball without them
    url "https://github.com/ClickHouse/clickhouse-odbc/archive/refs/tags/v1.5.3.20260311.tar.gz"
    sha256 "bb9311b48ddcd499ed2222a72a07f168f3d4909bd77ec69a78c665784b81c1c1"

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
    sha256 cellar: :any,                 arm64_tahoe:   "90eda86018d1c211b87860e180defafae0b0e7ade05aa4efe025df51cf9630d9"
    sha256 cellar: :any,                 arm64_sequoia: "107b8fb4ab03c49f851382c765ef44499da1e41c3328e21abb51468163a43520"
    sha256 cellar: :any,                 arm64_sonoma:  "5aeb354ed151e1faeab8ac96cc91feec0e8f9c0728b032ff39716c871d9efcd6"
    sha256 cellar: :any,                 sonoma:        "039b6b33f07640cd7021638d92e7d9510e16b004852d1cdc22f4890d6cf8e053"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f306f9790ec065cedb0ab885bfd55c77368c1ab0976ad98e8572be6029c648f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff745d4609f6029eb77599327ee0183d68cac4a22ada376d0bfff2ec89bb9331"
  end

  depends_on "cmake" => :build
  depends_on "folly" => :build
  depends_on "icu4c@78"
  depends_on "openssl@3"
  depends_on "poco"
  depends_on "unixodbc"

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
      pipe_output("#{Formula["unixodbc"].bin}/isql 'ClickHouse ODBC Test DSN A'", "quit\n")

    assert_match "Connected!",
      pipe_output("#{Formula["unixodbc"].bin}/iusql 'ClickHouse ODBC Test DSN W'", "quit\n")
  end
end
