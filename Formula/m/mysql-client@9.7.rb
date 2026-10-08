class MysqlClientAT97 < Formula
  desc "Open source relational database management system"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-9.7/mysql-9.7.2.tar.gz"
  sha256 "e5a676c7cb73738dc6ea33db2093806ebd512b629a139b897fcab68fcd81aaa4"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  revision 1

  livecheck do
    formula "mysql@9.7"
  end

  bottle do
    sha256 arm64_golden_gate: "c4fbad3c217ffbc0bba00434ec4cb4362be0a40ef3eba7069edb1e40b93edaf3"
    sha256 arm64_tahoe:       "2186232330bfcda2ce8f91c8ec46b973256928af3ab3f568d70b65b4f3d29eee"
    sha256 arm64_sequoia:     "4377987fb4472c1023893781c8de2b4c8e7e5ae1a3471979d9bbf680d53d4d5c"
    sha256 arm64_linux:       "1de2487698f14f7ea75c0366c3cb3b8a93773b9a3b6771fd1fc5ace313723ccf"
    sha256 x86_64_linux:      "f45c4cb3dd303a6605246d98be332395483e359bbdde980453efce0dda1ff9c4"
  end

  keg_only :versioned_formula

  # See: https://endoflife.date/mysql
  deprecate! date: "2034-04-21", because: :unsupported

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  depends_on "openssl@4"
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

  # Apply Debian's MySQL 9.7 patch to fix build with OpenSSL 4
  patch do
    url "https://salsa.debian.org/mariadb-team/mysql/-/raw/ac6576612c0afddccebf939fccedacc3b97db567/debian/patches/support-openssl4.patch"
    sha256 "fd0eb6d47ce5aaef43e58240d9884d04b1ee30fd3c57395b405d9400ae136a02"
    type :unofficial
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
