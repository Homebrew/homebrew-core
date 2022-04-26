class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.29.tar.gz"
  sha256 "fd34a84c65fc7b15609d55b1f5d128c4d5543a6b95fa638569c3277c5c7bb048"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_monterey: "027b3285464efef9f5009bd9b03e321bf66fc45e70f3e5642413ebee82de516f"
    sha256 arm64_big_sur:  "f227bc112499668be1cadb13ccb135c7f84a3611d0315d99430f1513c10674f5"
    sha256 monterey:       "8c7f6643d37cd4cd56cc3fa1fa9916291f66f1a387f6c3ba823f5d4063fb9f1b"
    sha256 big_sur:        "c548ebfd1833b464605ee358fec8db92876c0acbc3146f4f3e03ce144d9f4019"
    sha256 catalina:       "1739aec7b48397ba3d98c3c3f906ec2602713427e2b93900be0ced4174f75869"
    sha256 x86_64_linux:   "f634607785fe8ff2d484b5bd7b9f7af6457a8b35aa8871f68e7bb48e38c24d9b"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libfido2"
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
