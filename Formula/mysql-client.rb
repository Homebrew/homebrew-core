class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.26.tar.gz"
  sha256 "209442c1001c37bcbc001845e1dc623d654cefb555b47b528742a53bf21c0b4d"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_big_sur: "d18591b0da1378331d9bf4a05a3ab32aa11a4de378a74a8658e0dd61ae19ca67"
    sha256 big_sur:       "a7904ebb20e476aaae9cdacbe747591aebc9a12f1bf9dcde05c428a2680983cd"
    sha256 catalina:      "9cc3a6250aa0ef10fe984c6cb7c2339e2261e0f478cb37c4d0aa9ac097e24bb5"
    sha256 mojave:        "508a393ba7f4085fe2912aca915af65413a7372e2fee74ece6f8556f0c85e82e"
    sha256 x86_64_linux:  "e29ad59ea5a0f27d2cd0867595f67045385b86baa26ec473206c060546a39986"
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
