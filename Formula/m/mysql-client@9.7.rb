class MysqlClientAT97 < Formula
  desc "Open source relational database management system"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-9.7/mysql-9.7.2.tar.gz"
  sha256 "e5a676c7cb73738dc6ea33db2093806ebd512b629a139b897fcab68fcd81aaa4"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@9.7"
  end

  bottle do
    sha256 arm64_tahoe:   "2cca5383f81238797edc113ffb42a82581a1d89f35f4e659e14644726a3f4593"
    sha256 arm64_sequoia: "a732f3cc0b7defb8a9b6317bc7ee39ddd80a400818acf77394953428473467dd"
    sha256 arm64_sonoma:  "aa51605824dd336c42700dd73c14b2f14f3436593e34bfdf3eebfb2b1231c687"
    sha256 sonoma:        "acb57f24bea85cb21d1a1bcb8a2214570ca05627787be2fbf5ba987c851abab0"
    sha256 arm64_linux:   "29fd350bdf8c3f6e4cd53f9466f89290f8f833ae0a5d1689caab6ef3e837631a"
    sha256 x86_64_linux:  "52744624f607dbb78c94fddacbb102ecaebee9c3382b852d10312db5b00c2350"
  end

  keg_only :versioned_formula

  # See: https://endoflife.date/mysql
  deprecate! date: "2034-04-21", because: :unsupported

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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
