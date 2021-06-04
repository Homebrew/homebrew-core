class MysqlClientAT57 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.7/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-boost-5.7.32.tar.gz"
  sha256 "9a8a04a2b0116ccff9a8d8aace07aaeaacf47329b701c5dfa9fa4351d3f1933b"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "0fb106456fac4b96bee0ddd930ae8e13c9836b94339f11a699dfbfc2ee666363"
    sha256 big_sur:       "36a87c6407f067da00379be909a143ec825bef8e6def35a0c4787daafc930152"
    sha256 catalina:      "edad12cc0e3af651d3552ac645284167b06366be2b5e0c118fc644f1c23dea54"
    sha256 mojave:        "8d1f7732d3bdd6f5c83258dc72c0663a639ca3a3f0e852626c8c19b13a58cb4b"
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
