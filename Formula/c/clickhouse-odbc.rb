class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://github.com/ClickHouse/clickhouse-odbc"
  license "Apache-2.0"
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
    sha256 cellar: :any,                 arm64_tahoe:   "1df9cf15a855b47086b80a385370b3ef22f14774e00ed0331e3c88a8a8903644"
    sha256 cellar: :any,                 arm64_sequoia: "147b475605d4ac0c15f1771dbb69288166cfafbe62e63b99615981d28daaf21c"
    sha256 cellar: :any,                 arm64_sonoma:  "17447a50428f93393df7a4323e833e1ce764de04080dd308dc89a5756b241b2c"
    sha256 cellar: :any,                 sonoma:        "21214053e2d879a639eda76e026496a4124f96ac232989d135839ff518f60425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3da5879f8430d83a25b9d32ddb1996f311088f8f0bc04cde08c4114c443a76a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c2c3d6cfa04a1e0fc9c6ce0d34a3dd6d59ded916928aa0be17d33b4b407fbf1"
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
