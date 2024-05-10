class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.37.tar.gz"
  sha256 "fe0c7986f6a2d6a2ddf65e00aadb90fa6cb73da38c4172dc2b930dd1c2dc4af6"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  bottle do
    sha256 arm64_sonoma:   "875df46acc422a4c28201686a441fa50e131f480e4942c92e4b79ab8aa6740b7"
    sha256 arm64_ventura:  "c9f0638e3c6425a8fbfab8e741a75ce3103fcea9ebd291c57ca6d36e07e9ce74"
    sha256 arm64_monterey: "a122923981421ebecbfd246b4eab6f9eb06d3f6245b9c40771f31b05711fad72"
    sha256 sonoma:         "2408588d839a1aac79269bfeabf7ddefd81abfcea7d8f33aac4a5c76da6eec3e"
    sha256 ventura:        "acc2ae429e53d3081403f889cf893c618146cdf7f2986ddbdd1492bdf923eeb2"
    sha256 monterey:       "4ed8d9a2f0772d938c91cce4efe5b23fc12397be5c341e255fa438539cb04d59"
    sha256 x86_64_linux:   "885456ca30a98b84060f6ac82e2fac3a34e53f03f499f79ed4b7f3e607130ec0"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@3"
  depends_on "zlib" # Zlib 1.2.12+
  depends_on "zstd"

  uses_from_macos "libedit"

  fails_with gcc: "5"

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

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
