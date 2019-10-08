class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.7/en/"
  # Pinned at `5.7.*`
  url "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-boost-5.7.23.tar.gz"
  mirror "https://cdn.mysql.com/archives/mysql-5.7/mysql-boost-5.7.23.tar.gz"
  sha256 "d05700ec5c1c6dae9311059dc1713206c29597f09dbd237bf0679b3c6438e87a"
  revision 1

  bottle do
    sha256 "43faa86e44607a1a67189016b0f7d2ff15a484f9f80fc8e40e3c13a8eb662f9c" => :catalina
    sha256 "dc94d17faeea3a03f85299a8e93cd359dfff5fdff3576e50992506485f3029e2" => :mojave
    sha256 "cf37146a2e2144eef78e38f5893a6fdfddab2c95dd398666e0150a2621779645" => :high_sierra
    sha256 "663331c48538a961d42ea69a11555bc3f37f1f5b3e9a9e8f305ecbe490528b73" => :sierra
  end

  keg_only "conflicts with mysql"

  depends_on "cmake" => :build

  depends_on "openssl@1.1"

  def install
    # https://bugs.mysql.com/bug.php?id=87348
    # Fixes: "ADD_SUBDIRECTORY given source
    # 'storage/ndb' which is not an existing"
    inreplace "CMakeLists.txt", "ADD_SUBDIRECTORY(storage/ndb)", ""

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
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
