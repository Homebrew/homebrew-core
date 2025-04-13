class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.41.tar.gz"
  sha256 "719589993b1a6769edb82b59f28e0dab8d47df94fa53ac4e9340b7c5eaba937c"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  bottle do
    sha256 arm64_sequoia: "fa0d41d38ac39cdb0e76aaf8ed8934b752d8698ca62a1fcd5faa4af63c88c083"
    sha256 arm64_sonoma:  "e7a966df0518248e26b00359d751268519cfb4476854457a0f5b44bb5858a5cd"
    sha256 arm64_ventura: "9fac29cf31bd06a736c355cd669c3824ca9c34ad56088e621fe0249f10fff61e"
    sha256 sonoma:        "0be2cea19b6c1bce3a8e8059b6accb3dd83e20ee1cc104db537fe7b747241d05"
    sha256 ventura:       "7b3cbdeda4191c3d67db0acbaafc373859ede643864081e6fc84edf0f9749603"
    sha256 arm64_linux:   "28af24d70f18909793715af3f9af99c0d10c4968e1828a82909d830262f9fd14"
    sha256 x86_64_linux:  "fba059331650d7affa85c8b10e43c2afe7b8ea054f96ab679a4499b396c876db"
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
