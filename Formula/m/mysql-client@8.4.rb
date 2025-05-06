class MysqlClientAT84 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.4/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.5.tar.gz"
  sha256 "53639592a720a719fdfadf2c921b947eac86c06e333202e47667852a5781bd1a"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.4"
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "64277d6ec414f92e516089a4e2c6ad176fdb6152a607676392995002149a1a17"
    sha256 arm64_sonoma:  "43b670624ca50f578df25b7a8fa655bd31e283afa27083018f07d759cb43bfdf"
    sha256 arm64_ventura: "630f42abd4c09710dcd37691ed213e84aac2f1ebd10c56023ba1098265694b36"
    sha256 sonoma:        "2ff98ae96608ebb56f38ffbdccf9583902bf9bf75357d9ff4535814177f9b3c2"
    sha256 ventura:       "4b163c87cd423182b1ddfd4da72e81ddc3361994d9edd824c9f942164332681b"
    sha256 arm64_linux:   "8ba67332d9fb971c345746a9765de11e57b08df6b729c5119ab654df230a86e0"
    sha256 x86_64_linux:  "3f1027c7649a348bc50137d817aa9d119808ab02408431063fc5d71dd58761e6"
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
