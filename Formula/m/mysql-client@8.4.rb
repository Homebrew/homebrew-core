class MysqlClientAT84 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.4/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.4.tar.gz"
  sha256 "fb290ef748894434085249c31bca52ac71853124446ab218bb3bc502bf0082a5"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.4"
  end

  bottle do
    sha256 arm64_sequoia: "599ea595f393284cead24568d81ec80bd4c6e8d3a3f65149da1f2e5626722b8d"
    sha256 arm64_sonoma:  "7c7002d267e6e9e58ca7102a9d058b39624858fe53fd01659ca6e6e55e0f2ed9"
    sha256 arm64_ventura: "9cd7f7d4b32e37b550dfbac68a731049e99b45766905ba3e20f9702dd8de95dd"
    sha256 sonoma:        "4d88430aea70b98b39ebde69c8b48fb31204485561152b1cef8804677348f3be"
    sha256 ventura:       "b8799bfd328b28437096172d0e91525bef03ffbfbe86aa2d423dbeae655dd5f0"
    sha256 x86_64_linux:  "085b6fe95a460c34a4d0e66e877d5c741c29612596ee19378ba050af09f7637e"
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
