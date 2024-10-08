class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://github.com/ClickHouse/clickhouse-odbc"
  # Git modules are all for bundled libraries so can use tarball without them
  url "https://github.com/ClickHouse/clickhouse-odbc/archive/refs/tags/v1.2.1.20220905.tar.gz"
  sha256 "ca8666cbc7af9e5d4670cd05c9515152c34543e4f45e2bc8fa94bee90d724f1b"
  license "Apache-2.0"
  revision 5
  head "https://github.com/ClickHouse/clickhouse-odbc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40be2f72f18aa863a3e929298f52d222bcdec799d0b53ed8a5646795af61257b"
    sha256 cellar: :any,                 arm64_sonoma:  "3c459a141032eaf70f4f6b0b71fc9355c88a387f87e8b6c0ad37cc213639f8a5"
    sha256 cellar: :any,                 arm64_ventura: "0f98513d8f7541af8540d6dab6118eb9f3511056f9e96d197a4c333de4577e65"
    sha256 cellar: :any,                 sonoma:        "03686cc156b0de1824ab04e1e5f8db037e8f8209c756235361059b1eec7feae8"
    sha256 cellar: :any,                 ventura:       "bc95d4201a9cc1b760aed05b9cbe3ceb0761ffa94c82b1053b5799e1a12e2a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c76a973dfadd8f90847be90776ab666cb9248f81e2159e5b4ba34374b44a8b"
  end

  depends_on "cmake" => :build
  depends_on "folly" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@75"
  depends_on "openssl@3"
  depends_on "poco"

  on_macos do
    depends_on "libiodbc"
    depends_on "pcre2"
  end

  on_linux do
    depends_on "unixodbc"
  end

  fails_with :gcc do
    version "6"
  end

  def install
    # Remove bundled libraries
    %w[folly googletest nanodbc poco ssl].each { |l| rm_r(buildpath/"contrib"/l) }

    icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
    args = %W[
      -DCH_ODBC_PREFER_BUNDLED_THIRD_PARTIES=OFF
      -DCH_ODBC_THIRD_PARTY_LINK_STATIC=OFF
      -DICU_ROOT=#{icu4c_dep.to_formula.opt_prefix}
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
