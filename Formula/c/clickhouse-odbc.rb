class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://github.com/ClickHouse/clickhouse-odbc"
  # Git modules are all for bundled libraries so can use tarball without them
  url "https://github.com/ClickHouse/clickhouse-odbc/archive/refs/tags/v1.2.1.20220905.tar.gz"
  sha256 "ca8666cbc7af9e5d4670cd05c9515152c34543e4f45e2bc8fa94bee90d724f1b"
  license "Apache-2.0"
  revision 10
  head "https://github.com/ClickHouse/clickhouse-odbc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fac4f8638aab95398286ba3643e97dd262fa9ae44d9b8c664efef374411f1868"
    sha256 cellar: :any,                 arm64_sequoia: "20d55267bc68f23afbbf8c8f3e1dcdb7457b9f6028c8fdaa2ff81d56147d6d17"
    sha256 cellar: :any,                 arm64_sonoma:  "673d76f74f1a78fff36d0d4571f8d18d909434299de74e9fcf77f7135ff415a5"
    sha256 cellar: :any,                 sonoma:        "ba56a48154f82caf7bbf13ecee91a68cf5b3e994fef7f39d2cc54879786690dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3f3993599dacc6b9e64c9c81e94aef58fe89724671ac4a7d7a6313444ce88d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f52242f5c6add9f233d621e90b8c98b3a5eda4aa2f686f20d783177d1c88d90"
  end

  depends_on "cmake" => :build
  depends_on "folly" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "openssl@3"
  depends_on "poco"
  depends_on "utf8proc"

  on_macos do
    depends_on "libiodbc"
    depends_on "pcre2"
  end

  on_sequoia do
    # Workaround until successful version bump to >= 1.4.3 to get
    # https://github.com/ClickHouse/clickhouse-odbc/commit/574d58a6cfa94f27cc165374e32ef6eea7b7e0db
    depends_on xcode: ["16.4", :build]
  end

  on_linux do
    depends_on "unixodbc"
  end

  # build patch for utf8proc, no needed for newer version, as folly got removed per https://github.com/ClickHouse/clickhouse-odbc/pull/456
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/clickhouse-odbc/1.2.1.20220905-Utf8Proc.patch"
    sha256 "29f3aeaa05609d53b942903868cb52ddcfcb3b35d32e8075d152cd2ca0ff5242"
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
