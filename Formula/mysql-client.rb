class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.25.tar.gz"
  sha256 "93c5f57cbd69573a8d9798725edec52e92830f70c398a1afaaea2227db331728"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://github.com/mysql/mysql-server.git"
    regex(/^mysql[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "0a0869ca642cde40c30e34546709866dffca6f8572357be1b0eaf6addae98a5b"
    sha256 big_sur:       "b142f4a32fa04b62d4742a91b0e6b9322e709af367d692769012994e963f35c1"
    sha256 catalina:      "a2ff68b37407c8d189792925c7bb6dbbcdd2c78021a9121946bbfa9c8f37ec99"
    sha256 mojave:        "2a0463370835a04d6270113c31d6a4a6f2dd6fc8a845f9fa4c092c0f4c2ac49e"
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
