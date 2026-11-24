class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-26.10/mysql-26.10.0.1.tar.gz"
  mirror "https://repo.mysql.com/apt/ubuntu/pool/mysql-innovation/m/mysql-community/mysql-community_26.10.0.1.orig.tar.gz"
  sha256 "3d91f6b127ffd2fbd04794c1a11a364a4c73f89c8c44d1e2a07f5661a1b7a46a"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  compatibility_version 1

  livecheck do
    formula "mysql"
  end

  bottle do
    manifest_sha256 "cc6bb74e90cf819a8cf7ddb3ab6a44d0fe4b6b6e4612bbdbb71d373bb63515ff"
    sha256 arm64_golden_gate: "93312d43333561eacd21870eb39851d1e440f8e7bca2542be1a625a20353f60b"
    sha256 arm64_tahoe:       "e47c9092b3f3566353f9203a85c659923bba79ff84930f13a13b4f607bae5efd"
    sha256 arm64_sequoia:     "85699593804678b1e9c1fe3e257c016fea072e7af58df526a1544d84adafd536"
    sha256 arm64_linux:       "fd219134d7f33d102eacded9f97c48862da2871b18885f01967aa70a17a355b6"
    sha256 x86_64_linux:      "98c4108314b2c5d9111ec7df2f3ad617362ac8e066b34e9d5149c98273a9a4ea"
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
