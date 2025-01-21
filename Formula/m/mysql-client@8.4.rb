class MysqlClientAT84 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.4/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.3.tar.gz"
  sha256 "7ac9564c478022f73005ff89bbb40f67b381fc06d5518416bdffec75e625b818"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.4"
  end

  bottle do
    sha256 arm64_sequoia: "7755d99ebf536c9517bdcfae3f11cb60f413a3c17d11bddf678b2d24008a2f7b"
    sha256 arm64_sonoma:  "5b6f79d1c68802ffaf769299198b077bcbbb029278a5efbf8d7ed3d27f8814c3"
    sha256 arm64_ventura: "a37ee6f6ca36c249f36f2a2ea200e1db4c05708c544590197b095a1f1b07b12f"
    sha256 sonoma:        "b00c0f2da5776d58d43288939659c02a2bd888b0868b781125c1956bdd3a1190"
    sha256 ventura:       "e733854b88c2ef402232f5cf38c28135b5edb3ec5e07ed520a49dedce0e18b64"
    sha256 x86_64_linux:  "318aa274caaba5b18224a104619619f4f93d27a1eb1f56758490cc8eb7a30dc0"
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
