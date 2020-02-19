class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.18.tar.gz"
  sha256 "0eccd9d79c04ba0ca661136bb29085e3833d9c48ed022d0b9aba12236994186b"

  bottle do
    sha256 "6aeb496213d40f45bc44123703753012ea889468b7f37101a42772da237ab4ad" => :catalina
    sha256 "9729c80a49ac7b808bbc26a93130c3ea16797da3824ed9450df53974958de066" => :mojave
    sha256 "98ae3bb78d4044053cba6acc3cd3e4737cc71df2cd2afb68e0cbccfd27488de7" => :high_sierra
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build

  # GCC is not supported either, so exclude for El Capitan.
  depends_on :macos => :sierra if DevelopmentTools.clang_build_version < 900

  depends_on "openssl@1.1"

  # Required to fix issue with angled includes
  # https://bugs.gentoo.org/692644
  # https://bugzilla.redhat.com/1623950
  # https://bugs.mysql.com/92870
  # We'll use Gentoo patch until PR Homebrew/formula-patches#282 lands.
  patch :p1 do
    url "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-db/mysql-connector-c/files/mysql-connector-c-8.0.17-use-relative-include-path-for-udf_registration_types-h.patch"
    sha256 "606ab7ee0d1fe27a2638d917a47dd7763e97a635225ca44ece366f6613aea6b6"
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
