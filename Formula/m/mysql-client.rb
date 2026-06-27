class MysqlClient < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/9.3/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-9.7/mysql-9.7.1.tar.gz"
  mirror "https://repo.mysql.com/apt/ubuntu/pool/mysql-innovation/m/mysql-community/mysql-community_9.7.1.orig.tar.gz"
  sha256 "dabff263022be6a09151c21812322873437e0d77aec8c4cc7381882c3ea1aeae"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  compatibility_version 1

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_tahoe:   "03d34d106c64659e68c1c0937774297def7753bddd2202bb4239a1013efff876"
    sha256 arm64_sequoia: "e4f8e5898c2385f5ec7765d66c9ab8f81925e3f8a078ad59dfdc62fb82c40198"
    sha256 arm64_sonoma:  "51f5a9d6fdf2c295011501bb2546479a37565fd6243a4f981d06a8e25316a29e"
    sha256 sonoma:        "454b0f3f24004fb5581576a5820d41ea0ebb612781e525a09d8bf829375b6021"
    sha256 arm64_linux:   "fa86c98c83a5a8db01ab5648d1bdb72b217af061991729ff029ee157935c9fea"
    sha256 x86_64_linux:  "4565b4b828e693838d7f23c6d6e2d6eeefc6c8c916140a43381ce90852041241"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  depends_on "openssl@3"
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

    # Replace deprecated `std::is_trivial_v<T>`
    # https://isocpp.org/files/papers/P3247R2.html
    # Upstream report: https://bugs.mysql.com/bug.php?id=119246
    if OS.mac? && MacOS.version == :tahoe
      inreplace buildpath/"libs/mysql/gtid/tag_plain.h", "static_assert(std::is_trivial_v<Tag_plain>);", <<~CPP
        static_assert(std::is_trivially_default_constructible_v<Tag_plain>);
        static_assert(std::is_trivially_copyable_v<Tag_plain>);
      CPP
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
