class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.29.tar.gz"
  sha256 "fd34a84c65fc7b15609d55b1f5d128c4d5543a6b95fa638569c3277c5c7bb048"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_monterey: "0570baf2cf4c4b82ee8ea9fbcbe46ed296bf8d35e67af0c8825b9f771dc1b225"
    sha256 arm64_big_sur:  "a7c4c56992572994ede23bf0439bff5311e3591f84ec88841ba673cb1ae25562"
    sha256 monterey:       "25d0a5b775dbeb01c853132138b206cff6d5678ffd944ac3e28bc06f67d6a1d5"
    sha256 big_sur:        "8d952a3e0a7d6c43066aae7cc390a7c1acaef3519d1b25dc3196fc2e55dc320f"
    sha256 catalina:       "b7db816c2e28cd360ae4f460a2d4829243f7d260df89f8acc6611adde29df196"
    sha256 x86_64_linux:   "f7f7a44320c99f7ae6fe9eb0cc3da00a255b2070559be9ce9dcae35197983f68"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@1.1"
  depends_on "zstd"

  uses_from_macos "libedit"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

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
