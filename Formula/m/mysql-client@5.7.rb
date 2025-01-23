class MysqlClientAT57 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.7/en/"
  url "https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.42.tar.gz"
  sha256 "7e1a7d45e7ca382eb3a992f63631c380904dd49c89f3382ec950aef01997524f"

  bottle do
    sha256 arm64_sonoma:   "1bc3efd20113dbe76c87fee1871d171b9c55896b4a89a7ed7d1f235cb518b650"
    sha256 arm64_ventura:  "223ac8c2302eef56a26c1b76068581df25cfb19b92f2d7b04b281554d515d52d"
    sha256 arm64_monterey: "2ff11cb1eaf22ee421580481e1d1101c10b3e22ac670944fcc3630bb9b25d5f9"
    sha256 arm64_big_sur:  "ff7c8463bdf3a1b1064c82e6da8f8165f12684defcb68d57c4aa48d65045af14"
    sha256 sonoma:         "a83537cb5e942ece6ede11b1893c0f966204decd173b96fee15c3bd865df4c3f"
    sha256 ventura:        "d3d0898ebca83a38365b6aa72a31d2ea72ab1727c0ab576c8bf385eb9d8bcd48"
    sha256 monterey:       "9deda0454a1ab6be155966e328a6e1354bc19859efb35ad470615adf241691e2"
    sha256 big_sur:        "13a2302e62a0494ce327197bd877a453a7b97299dec4e0547b7d8ee37c3b48bb"
    sha256 x86_64_linux:   "ef8c64ab59f1df568cc8fb40340358cb69cc5623581f63bfd628db4f0562224a"
  end

  keg_only :versioned_formula

  disable! date: "2024-08-01", because: :unsupported

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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
