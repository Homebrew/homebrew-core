class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.36.tar.gz"
  sha256 "429c5f69f3722e31807e74119d157a023277af210bfee513443cae60ebd2a86d"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  bottle do
    sha256 arm64_sonoma:   "110504674c88fc1a39cda6a31e5bf5c4c566fd82f78fe4ce9c705e66e3778705"
    sha256 arm64_ventura:  "c8bee79f7b75434bef2beea4047d77f4a4b59ede8dbd0eabd5f1d67329242f49"
    sha256 arm64_monterey: "b48e9e9b4357094de72a5c5eb3b2a2fd6f883b3ee8baabfa6972e148d8aae2ea"
    sha256 sonoma:         "9aa3740259fc5d8451df2361f5d0dcd1ed6249a55b925d896528a98fe37338f5"
    sha256 ventura:        "42eec55ce4144c45233bc51902f8c35c4a0bc280769b6e0acfd416719bde4397"
    sha256 monterey:       "6f61b9192445ae4397a98097b452058930cbe41b8b3bc97d319e23c32749c10f"
    sha256 x86_64_linux:   "acae2fe099359280c03a7555ce0386aff54094e58b6327e3ff7088309b1bee25"
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
