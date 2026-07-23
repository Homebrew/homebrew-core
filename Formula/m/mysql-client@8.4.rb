class MysqlClientAT84 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.4/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.10.tar.gz"
  sha256 "d57a6730baef14ae118f7f4a6e02845b5b50933758df61fb06e104f27ccc8f96"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.4"
  end

  bottle do
    sha256 arm64_tahoe:   "bebb91df42ac75384c03dded692b642cf14344354f895bbf834996898a6768bf"
    sha256 arm64_sequoia: "ca334b4019bbe95bf0136cf478a30669cd7aec8a0e44936a41948e054fd79d12"
    sha256 arm64_sonoma:  "ef9c828c8db3b97eaffde1288b208871d48c19b6a2360f6243d7200ad2a18dc3"
    sha256 sonoma:        "b243d010ef22d4a59bb7cc09ff96050d710878412b5ca32052629a8d73477eb4"
    sha256 arm64_linux:   "eef43391ef1a42b01a7036b1ffcae7b58216fa01d874d4b1b161f37517e602ad"
    sha256 x86_64_linux:  "2580d243cd9de08fff8104c13f479656d492a7a3fe862a3e00de369460f4cc84"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libfido2"
  depends_on "openssl@3"
  depends_on "zlib-ng-compat" # Zlib 1.2.13+
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
