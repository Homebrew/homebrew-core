class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.39.tar.gz"
  sha256 "93208da9814116d81a384eae42120fd6c2ed507f1696064c510bc36047050241"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  bottle do
    sha256 arm64_sequoia:  "e5eec734188c806a932b962ee55417e56adea941ca812d32c0a3b22a8aba8025"
    sha256 arm64_sonoma:   "94f9d95b1f70fd2c8516b8f15b2fa8fde6cb5b008e148572ec4b44691ec8a483"
    sha256 arm64_ventura:  "545247f0de8d8ad2154f75f634fe7364a0d3944209f624c7ae4bc887388a2299"
    sha256 arm64_monterey: "ef03847f97d1045fe1774fffb5958be74714f02345d2fecccda1b81f1be04719"
    sha256 sonoma:         "1e583d33747d33b85a2b3204610e06a50be72d7eeea0561d531b8a1d9f2b4820"
    sha256 ventura:        "3018ce2137f0e0bcafbf29131c17e4b49effc150bcd76b35b7fcfd56ec504c81"
    sha256 monterey:       "adfebc82f75d42e4c925553a606672d25144d2d376f3b95f4186aa2919bf3242"
    sha256 x86_64_linux:   "e1c7ada416a7fcb506f90bdda22ddcd6268137b21ff8f470a54656eae1ea64a2"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@3"
  depends_on "zlib" # Zlib 1.2.13+
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
