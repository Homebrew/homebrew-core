class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.7/en/"
  # Pinned at `5.7.*`
  url "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-boost-5.7.23.tar.gz"
  sha256 "d05700ec5c1c6dae9311059dc1713206c29597f09dbd237bf0679b3c6438e87a"

  bottle do
    sha256 "a551209c7b65e98230cd157d70457feec48fdd34e6638e56759f299a55212c39" => :high_sierra
    sha256 "4bf7226a728b4daf4b45913e0e8fe2460165c04c3b24927d10e90181e018e93b" => :sierra
    sha256 "564c6b1b66d6f91663c98c136b036398691393c7c90f671f12e535ed0cdc7b6d" => :el_capitan
  end

  keg_only "conflicts with mysql"

  depends_on "cmake" => :build
  # https://github.com/Homebrew/homebrew-core/issues/1475
  # Needs at least Clang 3.3, which shipped alongside Lion.
  # Note: MySQL themselves don't support anything below El Capitan.
  depends_on :macos => :lion
  depends_on "openssl"

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
