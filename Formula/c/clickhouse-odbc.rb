class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://github.com/ClickHouse/clickhouse-odbc"
  # Git modules are all for bundled libraries so can use tarball without them
  url "https://github.com/ClickHouse/clickhouse-odbc/archive/refs/tags/v1.2.1.20220905.tar.gz"
  sha256 "ca8666cbc7af9e5d4670cd05c9515152c34543e4f45e2bc8fa94bee90d724f1b"
  license "Apache-2.0"
  revision 9
  head "https://github.com/ClickHouse/clickhouse-odbc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "823b627489c0eb6132863b4801bbb35d72d0a0a94e6a05e1db727626d6610a97"
    sha256 cellar: :any,                 arm64_sonoma:  "e3319686c6b8b190cac07657b005815d52b5e9ae2cdce502dc0547b2beec2d33"
    sha256 cellar: :any,                 arm64_ventura: "fd57a1b662562034e4438ef7a3f504a13b9bb41fd1fdf0fba65881457c3dbad9"
    sha256 cellar: :any,                 sonoma:        "9e6d19fe3f32091196b620af7a2505a67e1bff07af8379a328f98e99ae5f8c6e"
    sha256 cellar: :any,                 ventura:       "b05b85f7872bdea82c386d7f6f8a865237e6691539f9f7fa51d0b91513fabde0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83be34ed8d3397d1b48962b0c5584093442d667208061fab3f699401d943f580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d8fcd33563bd470e0c3642123a9be187196aa6678061134a4590d4679e841a1"
  end

  depends_on "cmake" => :build
  depends_on "folly" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
  depends_on "openssl@3"
  depends_on "poco"
  depends_on "utf8proc"

  on_macos do
    depends_on "libiodbc"
    depends_on "pcre2"
  end

  on_linux do
    depends_on "unixodbc"
  end

  # build patch for utf8proc, no needed for newer version, as folly got removed per https://github.com/ClickHouse/clickhouse-odbc/pull/456
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c76519fcbfa664cd37a8901deb76403b1af1bec1/clickhouse-odbc/1.2.1.20220905-Utf8Proc.patch"
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
