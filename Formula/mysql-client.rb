class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.27.tar.gz"
  sha256 "74b5bc6ff88fe225560174a24b7d5ff139f4c17271c43000dbcf3dcc9507b3f9"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_monterey: "62f968266266f4ada9328d1f183c913bdeae4984dd032d657dc86e49fde7b044"
    sha256 arm64_big_sur:  "8b663d7d600724c9a78085a0099ff989afa8e11b77b22ff656614c73cf71c1a0"
    sha256 monterey:       "658ee76f01d99fd12d6a176a37c76ce1496e2847cf8d7efd031824476d08f261"
    sha256 big_sur:        "fccbb65d06dade7a89960791c8c60a310b1789322a573285cdd32b3f4ed66938"
    sha256 catalina:       "d51daf18cd3886b495363981ee421a54bb77080956d2905440bf2648e410fb14"
    sha256 mojave:         "2c963d4cae0a100169890d81db4bb73c680efd54236346af83b4766db1e389c0"
    sha256 x86_64_linux:   "e56be57cf7f3e415720ceebbb4f50a073db2a3276618d550354d74539f430edf"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build
  depends_on "libevent"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@1.1"
  depends_on "zstd"

  uses_from_macos "libedit"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # Fix build on Monterey.
  # Remove with the next version.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fcbea58e245ea562fbb749bfe6e1ab178fd10025/mysql/monterey.diff"
    sha256 "6709edb2393000bd89acf2d86ad0876bde3b84f46884d3cba7463cd346234f6f"
  end

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
