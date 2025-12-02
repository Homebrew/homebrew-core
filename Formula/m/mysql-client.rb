class MysqlClient < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/9.3/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-9.5/mysql-9.5.0.tar.gz"
  mirror "https://repo.mysql.com/apt/ubuntu/pool/mysql-innovation/m/mysql-community/mysql-community_9.5.0.orig.tar.gz"
  sha256 "ef3343981375865a2519f72b600e55f9c646e60e204a2964d3b7e8e748a110a5"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "7e7f49974ddd1ffa219c434bd1ea40f1eb3363b81820f57217f3a8581b57d79c"
    sha256 arm64_sequoia: "10be20065f9c0e3564061363f4484587a11f8e9cd82f218635327ee0a91c4abd"
    sha256 arm64_sonoma:  "c1875651500d46033ad8e047d58baa95b65f54afc8e4db3b9a103aae82456cda"
    sha256 sonoma:        "72fb863389cc891461b891e92013ab4e1d855168c58c7909d84e74201e06b45f"
    sha256 arm64_linux:   "6a4deb358547538a5256d2795cac778264cb06919e0b9d6d52175d2251e4bb08"
    sha256 x86_64_linux:  "49a34adedb283f40e336e722b52d9dc72328ce81159cc3fb03a0dd70666f0d74"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  depends_on "openssl@3"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

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

  def install
    if OS.linux?
      # Disable ABI checking
      inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"
    elsif MacOS.version <= :ventura
      ENV.llvm_clang
    end

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
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
