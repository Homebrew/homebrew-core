class MysqlClientAT97 < Formula
  desc "Open source relational database management system"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-9.7/mysql-9.7.4.1.tar.gz"
  sha256 "7f399c598797c6fc0de9a97cbd68008150396ab32cb27f8bcb9746217371237f"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@9.7"
  end

  bottle do
    manifest_sha256 "ee4f7ec378511a275d5aca73956c826de998412587dbde6ff626cf446ec09d20"
    sha256 arm64_golden_gate: "02bb87e9f75d7a199dd5557d9d2aafc16c7d8bf96a76de711de6472134a987b4"
    sha256 arm64_tahoe:       "1288736f612bd0435e9025dca452eda315683f14e8028dc8da6b5f092fe2f3a7"
    sha256 arm64_sequoia:     "5074b6cc128d91a631caaab8dce7db4065576d807ff42ed74e30fac6f4fc6235"
    sha256 arm64_linux:       "a3d1d03d078044fd07e4387fed39db4c31b7b59d2b1cef0a6bd8ded313623e4f"
    sha256 x86_64_linux:      "32d7bae413f338a48702d5ec62b95e19892633bb300886463a0fac091e96821f"
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
