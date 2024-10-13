class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/9.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-9.0/mysql-9.0.1.tar.gz"
  sha256 "18fa65f1ea6aea71e418fe0548552d9a28de68e2b8bc3ba9536599eb459a6606"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_sequoia:  "b1476498505c15afd4734528f8d5611c2ba823c023b6313cb603c76eb79203fa"
    sha256 arm64_sonoma:   "a60550ca6925d3ad75ffefb38b782800f58511f586e607faa73273a41355841d"
    sha256 arm64_ventura:  "4fc42b3455b6dc68ed0a83b38eae48eee8c907b72974ff4c76a00ec7a0d08997"
    sha256 arm64_monterey: "1b3b1f059ad68568f70d142d48f132501327aa376d8bea673bf1900834a1b094"
    sha256 sonoma:         "5971074a3003479b0781bd4a44b1b009cc7c790357cc549b5d45074ee74572b8"
    sha256 ventura:        "876135b9828ec40320e1a5c5ce082c85307732a212ba79027f39216a238cd765"
    sha256 monterey:       "6ea086c4b5b684ff226b6d588d535dc0313e987c9e65cb7b42945262720af528"
    sha256 x86_64_linux:   "e1d9c62f5e9c2111062a388403b2149259014fd0213bb1f82d1619c9b5e88d2a"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
