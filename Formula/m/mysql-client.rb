class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/9.1/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-9.1/mysql-9.1.0.tar.gz"
  sha256 "52c3675239bfd9d3c83224ff2002aa6e286fab97bf5b2b5ca1a85c9c347766fc"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_sequoia: "57bd260ff2bb4438de6c026f47e42173803a22623aa4a391ad4b4bd4363df01a"
    sha256 arm64_sonoma:  "64fb448cdd43c733d1a36bdc5bd313e98fe819cab4a68f1c0dc1c01f3f8b2e9c"
    sha256 arm64_ventura: "873df2cd90b7ebaf2fb7691b87be0cde4b0afcad6ad126f6a09572ec5c1d062c"
    sha256 sonoma:        "e68d457789de2bf7f9071c06f5874f595cfc5933b52344800cc7deda1fbc3044"
    sha256 ventura:       "a0db8fd37329414aedfb1be8def7ce698084468c2e34575deae563d4f67f5591"
    sha256 x86_64_linux:  "b7d775433dc1802356181133202bd2468b9b569a2f9a367d87b4556f8f0f7057"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

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

  # std::string_view is not fully compatible with the libc++ shipped
  # with ventura, so we need to use the LLVM libc++ instead.
  on_ventura :or_older do
    depends_on "llvm@18"
    fails_with :clang
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    if OS.linux?
      # Disable ABI checking
      inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"
    elsif MacOS.version <= :ventura
      ENV["CC"] = Formula["llvm@18"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm@18"].opt_bin/"clang++"
    end
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
      -DWITH_AUTHENTICATION_CLIENT_PLUGINS=yes
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
