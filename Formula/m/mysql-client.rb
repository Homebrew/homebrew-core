class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.3/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.3/mysql-boost-8.3.0.tar.gz"
  sha256 "f0a73556b8a417bc4dc6d2d78909080512beb891930cd93d0740d22207be285b"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_sonoma:   "26d634762424b716b062db2f0aea99069ed49c4d23a87eb25228a60d0a5bc91e"
    sha256 arm64_ventura:  "0e78b5b70727e5bb9a490e808a446a57a99df5d0fe74012b9be664e8236be69b"
    sha256 arm64_monterey: "5e07b7a43e907a34419300aec04bf76c0a8052b8d4efb938a02f8facc371a743"
    sha256 sonoma:         "db91051fc4112fc3b312d99c3cc003c56b263d7c0c52e527621bb3a86bb70ae7"
    sha256 ventura:        "7a346ad55b7f7530c1b60d5d8852f7418299e50e7a774af4d04695f292fd9e6b"
    sha256 monterey:       "8fbccabc53d77cbacb46d80ffa13a81dd9b8719a5b19e23704c1c91f906abe92"
    sha256 x86_64_linux:   "17b4319a7f67222566227fe45687482683832672cd6657dd523f577e1e7ae00d"
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
