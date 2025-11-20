class MysqlClientAT84 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.4/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.7.tar.gz"
  sha256 "c0bf33a94cdb908f149aea0797affb1b139262ccf0e0b9787a17246207542e69"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.4"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "f1fce38da138e20340738cae889eedede5d13567b83fa2f33dc71244d976501a"
    sha256 arm64_sequoia: "7bb69a79ff46691d2af3ac50b6facbe815b280fb55376fb5467d2dc261e7f5fb"
    sha256 arm64_sonoma:  "2fe0ede4c906e97fa87fc931bb5a8c153664764d538848a8d49f98fb8ef77c9a"
    sha256 sonoma:        "f0bc9e781b5befdcff2a0cc2ee205871c191718e466d4a7175dc2a58ab6ce019"
    sha256 arm64_linux:   "9e95149876220da1200d660f02de6d4433ba3167e053ca6caef4f55abcaab299"
    sha256 x86_64_linux:  "2310a36ed49b6a3bc9a52a3d6ee5eb0ad37f39db597c9551446d7a3fa9a9d9ea"
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
