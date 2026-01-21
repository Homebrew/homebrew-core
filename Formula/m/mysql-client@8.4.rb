class MysqlClientAT84 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.4/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.8.tar.gz"
  sha256 "be9d96cdf87f276952a2cdd960f106b960a8860e46c115ed39c1b5f2e0387a20"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.4"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "11b5bd71e57e1ead97e37aee839afeaec5b2e698bee2b2f243de699fe0d2c49e"
    sha256 arm64_sequoia: "26f99cd2d264a2ec2071fbb6934d24d60e429e5a84f87fa8e6e2005a7845e20d"
    sha256 arm64_sonoma:  "85f46c7470faff12a419ed45f9d484bf16aa4875f3fa75989587ff005d9ffd81"
    sha256 sonoma:        "c00f564ad650771344eced353ad61071e9df7eb3e3ecc9d880620a0d9e5c587c"
    sha256 arm64_linux:   "bb50206d962330a0ecd537fae5a0a91c7954247f551b536367301e76b82c6a15"
    sha256 x86_64_linux:  "ab0cc43e029cc8832dcdcf9897cbc615e3abafc0ac1905d9611931986f676b9c"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libfido2"
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
