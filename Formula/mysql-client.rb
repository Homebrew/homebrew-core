class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.28.tar.gz"
  sha256 "6dd0303998e70066d36905bd8fef1c01228ea182dbfbabc6c22ebacdbf8b5941"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  revision 1

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_monterey: "8564876235a72f8e8d695bfef6a004b6240250acbbc364e6504837c944576ff8"
    sha256 arm64_big_sur:  "e2322749d2d3137cebacbd73d0b5fa3ad6caaeb76be86ab9fa84bdc41851dbd2"
    sha256 monterey:       "fc037da725fac5450fd5246b0ba2854c963ca90f1b1ebff34f111dc4bcc41a80"
    sha256 big_sur:        "2a4de24361f2b52fd8cf4f8e3cdaefffaa09643df4253098515cb82fcf2c452d"
    sha256 catalina:       "06e005e2cf6377a9f28b295f201bec9d52d9c7a9631d84f1d788145687611898"
    sha256 x86_64_linux:   "03e040526cc6ec6ac2320f9445b63b4d0f6094889d080a696a2560d7b6548f19"
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

  # Fix libfibo2 finding; fix unneeded coping of openssl@1.1 libs
  # Remove in the next version (8.0.29)
  patch do
    url "https://github.com/mysql/mysql-server/commit/4498aef6d4a1fd266cdbddcce60965e3cb12fe1a.patch?full_index=1"
    sha256 "09246d7f3a141adfc616bafb83f927648865eeb613f0726514fcb0aa6815d98b"
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

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
