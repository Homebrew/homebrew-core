class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.45.tar.gz"
  sha256 "f679707d05f0c2b61e9b14961302e7f540c23e9e5e2bffd8ad9193599e295cee"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "e0eee02438c1171ce3b91f7169fc736ec5726121b2f18f9faabe86d57bfa9762"
    sha256 arm64_sequoia: "986fbca72239104460859c4c49116ec7487347a9b4559c632bc4a731875b0a59"
    sha256 arm64_sonoma:  "09fe421464e5cece5defe612b3e7249fc9badd2273f21e462530f5f91a9fb7da"
    sha256 sonoma:        "a1c6b120c3459343c2904e08998f8b08df8245ed96de9da0fc33a95fd414f0fc"
    sha256 arm64_linux:   "93b7add6884734fbb9725277ea5ff92d2b683ee422830d8c8412ed8ef0622868"
    sha256 x86_64_linux:  "60fcf50ff63a630ce3d4e65a0130956a008e55958ca572a128bc2188dde00281"
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
