class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.31.tar.gz"
  sha256 "7867f3fd8ca423d283a6162c819c766863ecffbf9b59b4756dc7bb81184c1d6a"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_ventura:  "904fe3369d3c805047ba09ad48a1bce232df4cfcb765a1a989f016b5fa1d4e27"
    sha256 arm64_monterey: "b565b9a2fb30bd5d4f1698f8942f499b45d31a70f7df08b21461dfecd9f735fb"
    sha256 arm64_big_sur:  "54a26c071f2945eb906e9c093f84f61421af8439cbc9441138cb28ebc842e067"
    sha256 ventura:        "3bc026f867b5aaf17181b80e03cf6c32a9afeea9b29eaade1c7e34547618cfbb"
    sha256 monterey:       "c0c6fa0acae0cd96c7c47c76e9816bcc945517f15080fc9704b9394ba077bc56"
    sha256 big_sur:        "bd32db39d4bc8d277129968f4bfbf664c8a2ad5844bcfb48d33c2f162c8b974c"
    sha256 catalina:       "51a429486ee4dec872cc9f8ca1484c0238ec13d8538813a5dc88aac85bd0e9e2"
    sha256 x86_64_linux:   "97869ddde4569e69dcd162b12cf8fe1c35f348d640630170664d84a2f20a0ecd"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@1.1"
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
