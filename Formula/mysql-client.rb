class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.23.tar.gz"
  sha256 "1c7a424303c134758e59607a0b3172e43a21a27ff08e8c88c2439ffd4fc724a5"

  livecheck do
    url "https://github.com/mysql/mysql-server.git"
    regex(/^mysql[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "02cad9438e1a062e2cf02f006390c7647ccd7c3c92f57cabd0e0d8b55259eecc" => :big_sur
    sha256 "b2181da5d62a186b2793910d0e6bfe63034c987b5e2cb213ee06d59ca0e2f95b" => :arm64_big_sur
    sha256 "3c25ba886b303c2598a2d874d00b8120a25391b48eac15bdaf1299c712ccc96a" => :catalina
    sha256 "1c8d885052492be90fa3d3df356eafca578a6bf27c439635a2d5dddf9417c4c4" => :mojave
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@1.1"

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
