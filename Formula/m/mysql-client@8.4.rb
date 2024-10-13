class MysqlClientAT84 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.4/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.2.tar.gz"
  sha256 "5657a78dc86bf0bf2227e0b05f8de5a2c447a816a112ffa26fa70083bcbe9814"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.4"
  end

  bottle do
    sha256 arm64_sequoia:  "05a8ffd022ab5dcf286a2d12a6b38c21d29984b16c4229515caaf6a7867e2327"
    sha256 arm64_sonoma:   "8684e4bc1f5d8b3038c4f66a7c975169d54d539fa651dc55c8e2ea2ae5b90bc0"
    sha256 arm64_ventura:  "1b9139148713510e6b5f673422794e56db746f8fb5ef04083bd7464e79f645b9"
    sha256 arm64_monterey: "94b5558a918c6666de072ce296aa83bde2a6404bd10b945771c08fc91cdd0246"
    sha256 sonoma:         "6b47b2ab1e8fb4a9edcd7e1d4a861e3a1241392a714d0434ec2a3b0a61786b1d"
    sha256 ventura:        "e09c5e49038d3aadb4a5973a1724edca418d80da2edbe047dcd00abc93599c61"
    sha256 monterey:       "fcf5e7e9f58425f8799f96fb580ad6dbdcfb9d5e09e8ca62562f0ff17a929dc5"
    sha256 x86_64_linux:   "4d30ae0cf8e2585962a2d4aee480099f4e468d4531736a0df2536b72112df7f9"
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
