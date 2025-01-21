class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.40.tar.gz"
  sha256 "eb34a23d324584688199b4222242f4623ea7bca457a3191cd7a106c63a7837d9"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  bottle do
    sha256 arm64_sequoia: "66cd479cef8a0979a134fc6dc75b1ed0b6d210e96d5199a3727e1d83f696f0dd"
    sha256 arm64_sonoma:  "e1849e4bd1c7546d473a3cc59d0f8dbdb35239057979488e159987576be1fd56"
    sha256 arm64_ventura: "a22a65c2c1ca6425a62cb12a602a2398fc49298a18a22c5b53ced9e71accd7bd"
    sha256 sonoma:        "c524071d6eabb6b16b17e8ee417f43e8147b9bf196774f9deb272b4eb1ba12b4"
    sha256 ventura:       "530ebc9494e8affdc5408dde06a7f7214d828a90df23b825a8194a7c22b693d5"
    sha256 x86_64_linux:  "1eeb1576f77d5c82bed931566dda39b99e2f3e14a5cf494d626748ca671c9ef2"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@3"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "libedit"

  def install
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DFORCE_INSOURCE_BUILD=1
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_LIBEVENT=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
