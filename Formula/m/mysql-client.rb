class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-26.7/mysql-26.7.0.tar.gz"
  mirror "https://repo.mysql.com/apt/ubuntu/pool/mysql-innovation/m/mysql-community/mysql-community_26.7.0.orig.tar.gz"
  sha256 "95e949183b94bbe39e70c6355e6c90d2a640a62ede996ca5f7a6a3e0827a3260"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  compatibility_version 1

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_tahoe:   "3f655342bbb90437bdd0fc133d828d10d9b180d538a872a87f8cf2c5b03f5e67"
    sha256 arm64_sequoia: "17894b365f010f08663cb42480338e10a71b7a0dc06af080a004e6d55964e080"
    sha256 arm64_sonoma:  "ce8fe4eb5db85e2d7ff9a24ae44f9dfdd97eabc9f4d6842c367e302491faed71"
    sha256 sonoma:        "8f98c6afa096b5f28cc5817fa102885646bb24c9a312670a117f5397ed495f88"
    sha256 arm64_linux:   "dbd664e5e0d8104215a60d2876f27e6a79ddddf7cc168f57a7aebe0e5be9a130"
    sha256 x86_64_linux:  "f285392a0803303256db9c87b1ac56ee208b16715fa764c55ac59e51abd05ab8"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  depends_on "openssl@3"
  depends_on "zlib-ng-compat" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"

  on_ventura :or_older do
    depends_on "llvm" => :build
    fails_with :clang do
      cause <<~EOS
        std::string_view is not fully compatible with the libc++ shipped
        with ventura, so we need to use the LLVM libc++ instead.
      EOS
    end
  end

  on_linux do
    depends_on "libtirpc" => :build
    depends_on "krb5"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    # Disable ABI checking
    inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_AUTHENTICATION_CLIENT_PLUGINS=yes
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
      -DWITH_MYSQL_CLIENT_TELEMETRY=OFF
    ]

    if OS.linux?
      args << "-DCURL_LIBRARY=#{formula_opt_lib("curl")}"
      args << "-DCURL_INCLUDE_DIR=#{formula_opt_include("curl")}"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
