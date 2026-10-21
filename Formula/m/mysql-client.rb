class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-26.7/mysql-26.7.0.tar.gz"
  mirror "https://repo.mysql.com/apt/ubuntu/pool/mysql-innovation/m/mysql-community/mysql-community_26.7.0.orig.tar.gz"
  sha256 "95e949183b94bbe39e70c6355e6c90d2a640a62ede996ca5f7a6a3e0827a3260"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  revision 1
  compatibility_version 1

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_golden_gate: "e5422fa29a31e272a1b5310ec3e632013456b1dd84fc956072b1d6209143c561"
    sha256 arm64_tahoe:       "7b56cfbd954b5d32dbcc6a1a5b8fb4b9d4b04215e5e87b40048534c23651f81c"
    sha256 arm64_sequoia:     "372dadbd91890643dd4cba1fbb3f93197d55ac2e403ca5d0a59fb2540bee1026"
    sha256 arm64_linux:       "ada9fe6a9dac6ebe8045ad7839fb24549d40ce4d766e06463dc9c9f9c23b95c8"
    sha256 x86_64_linux:      "bda96712fdd683b3ccf1439f0aec0be9d40a47a84daa205cab77e0007e725b9f"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  depends_on "openssl@4"
  depends_on "zlib-ng-compat" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"

  on_ventura :or_older do
    depends_on "llvm" => :build
    fails_with :clang do
      cause <<~EOS
        std::string_view is not fully compatible with the libc++ shipped
        with ventura, so we need to use the LLVM libc++ instead.
      EOS
    end
  end

  on_linux do
    depends_on "libtirpc" => :build
    depends_on "krb5"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  # Backports to support OpenSSL 4
  patch do
    file "Patches/mysql/26.7.0.diff"
    type :backport # https://github.com/mysql/mysql-server/commit/04ba58a223afc1339c75b080825042ad17a85b43
  end
  patch do
    url "https://github.com/mysql/mysql-server/commit/a045c23214ec225c49d9bc4caeea78d3d1f99ba9.patch?full_index=1"
    sha256 "b597781554b7fbcf4e13402dc8dca97bea59e059ed6e40e4eb71cd5c26a91ad9"
    type :backport
  end

  deny_network_access!

  def install
    # Disable ABI checking
    inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_AUTHENTICATION_CLIENT_PLUGINS=yes
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
      -DWITH_MYSQL_CLIENT_TELEMETRY=OFF
    ]

    if OS.linux?
      args << "-DCURL_LIBRARY=#{formula_opt_lib("curl")}"
      args << "-DCURL_INCLUDE_DIR=#{formula_opt_include("curl")}"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
