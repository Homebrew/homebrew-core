class MysqlClientAT57 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.7/en/"
  url "https://cdn.mysql.com/archives/mysql-5.7/mysql-boost-5.7.34.tar.gz"
  sha256 "5bc2c7c0bb944b5bb219480dde3c1caeb049e7351b5bba94c3b00ac207929c7b"

  bottle do
    sha256 arm64_ventura:  "87d24fa8e0c274b3e6e7ebe850da9e6a30a7c5dc8ff02abdd5fabef452e8bb9b"
    sha256 arm64_monterey: "a625d490e1aec7c1c940d4820a4296785f0d5885a5f44f207089b69ab14e4a13"
    sha256 arm64_big_sur:  "36dad98547a79e55ee6402bcfe841ab90e4f3ed8a0f22004a5d8e7b7e832ad3b"
    sha256 ventura:        "54ec10ea7264ebbd515f96fc4b2d3e78060d990c1c50a6e403296f4684e8c9e9"
    sha256 monterey:       "9591ce6380dc73dddd90716de26127b6269b3bb1d79ff3d821f7d59deb3513b8"
    sha256 big_sur:        "b00ea0ee1635933022d25b996a789fd57896c090526b86d767d1e868beaf82ad"
    sha256 catalina:       "8a9414707afa3c8462e45ef54f2da13361e96e8bbfb74102491bc28844a115fc"
    sha256 mojave:         "de54dc5ec1aaacf144cfeea5f2ba560450279f0464d44c0d3210c11b828efdfb"
    sha256 x86_64_linux:   "043c4687dce671f68a0e9023656086ab5a100f3b1151e30a4cd53ff3c08e5736"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build

  depends_on "openssl@1.1"

  uses_from_macos "libedit"

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
