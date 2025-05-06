class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.42.tar.gz"
  sha256 "c2aa67c618edfa1bc379107fe819ca8e94cba5d85f156d1053b8fedc88cc5f8f"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  bottle do
    sha256 arm64_sequoia: "59d43aed334afcda44273940a08e0a60d50228607fbd57965657f25578e3fd61"
    sha256 arm64_sonoma:  "ced161166185b2f6c1dc0676b771a4d794eb5bcaa85393411993bb7b8c6a31de"
    sha256 arm64_ventura: "b18647515429259f046aa0fb49e93929cbed48065d506e6260962b7e4ad87d5e"
    sha256 sonoma:        "e282d68aadf1142ac6058970a904b323c8483e6a72eda42e987b7078218136d8"
    sha256 ventura:       "cb190923a14eb844124f48aa292aeb696220f96231dd6be5cac916ea4cb5a7bb"
    sha256 arm64_linux:   "cf5203c31e25fafe9f5b0663262fcd36abf05be669337ca10a0eedf4bc9deaf8"
    sha256 x86_64_linux:  "3b94ce7a61aca93ad2c91e7f387231cb490a603e22cb9ed5869a7e7cde2abe25"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@3"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "libedit"

  on_linux do
    depends_on "libtirpc" => :build
  end

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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
