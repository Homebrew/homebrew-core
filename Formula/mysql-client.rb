class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.31.tar.gz"
  sha256 "7867f3fd8ca423d283a6162c819c766863ecffbf9b59b4756dc7bb81184c1d6a"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "17895bca9ba923b7fb85e5f7d400fb0ad71f18a4f3899cb737f7c0e2c777b3e8"
    sha256 arm64_big_sur:  "14cc13aa93faef1ed511d17ccd437feac78fcb6fa47e08749d57f33f286a4b7c"
    sha256 monterey:       "59effc912ee39a20b56d9c76bb35d2c233ab7f17aabe41dcb64224cee640f7f5"
    sha256 big_sur:        "3987bd3e7443f6b9332a345e775484b26feec6ddb1e48a96defbea851f02ee15"
    sha256 catalina:       "13dc71e64aff7cffce2cde557f6c85480c65260f2abe542e039280f928ee9911"
    sha256 x86_64_linux:   "a4c9f53a1c84a345be737a29403f686a96b813e5c4d4b1002dccb5e74819de56"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@1.1"
  depends_on "zlib" # Zlib 1.2.12+
  depends_on "zstd"

  uses_from_macos "libedit"

  fails_with gcc: "5"

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

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
