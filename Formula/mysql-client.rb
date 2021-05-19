class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.25.tar.gz"
  sha256 "93c5f57cbd69573a8d9798725edec52e92830f70c398a1afaaea2227db331728"

  livecheck do
    url "https://github.com/mysql/mysql-server.git"
    regex(/^mysql[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "b2181da5d62a186b2793910d0e6bfe63034c987b5e2cb213ee06d59ca0e2f95b"
    sha256 big_sur:       "02cad9438e1a062e2cf02f006390c7647ccd7c3c92f57cabd0e0d8b55259eecc"
    sha256 catalina:      "3c25ba886b303c2598a2d874d00b8120a25391b48eac15bdaf1299c712ccc96a"
    sha256 mojave:        "1c8d885052492be90fa3d3df356eafca578a6bf27c439635a2d5dddf9417c4c4"
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
