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
    sha256 "bae5404e9b7f56c094333b0b07085c1c9c85779f69766064f3b282e6f2340cbc" => :big_sur
    sha256 "87b578ab957fc937198383998026fb87a02de132aa0396a342c10fc55e709146" => :arm64_big_sur
    sha256 "533b8b6535afa3463f01296e7c66c8c5b059684c2fafd841ba96fe29bfc14d8f" => :catalina
    sha256 "3facd2969b6da9d1cde0d73a798b121c1a47cf507ed5a655ef8a288b92ddc23a" => :mojave
    sha256 "fd77cb216f782f15d82a493ab9ec33d533e540027bb65aa406a3db5e134b821a" => :high_sierra
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
