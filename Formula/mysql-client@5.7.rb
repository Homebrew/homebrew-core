class MysqlClientAT57 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.7/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-boost-5.7.32.tar.gz"
  sha256 "9a8a04a2b0116ccff9a8d8aace07aaeaacf47329b701c5dfa9fa4351d3f1933b"

  bottle do
    sha256 "61ca8bedda853898d6fca0036a520a39f514e33aca2ce691fa7e889b81790706" => :big_sur
    sha256 "c5752cf67dff22a4e32b0c32651eb73d898adf04528a25d2a17e64ff2bc05374" => :arm64_big_sur
    sha256 "effec4ea0f7867d42ea33ee16d6ea523e09f7ba9fe4e60fd9d55e6a6c577d2f8" => :catalina
    sha256 "0991a1d5fcb24e23761f8ca17d4896b46054ac80aca88d4eca17b944fbb178f2" => :mojave
  end

  keg_only :versioned_formula

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
