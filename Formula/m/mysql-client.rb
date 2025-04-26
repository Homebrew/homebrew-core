class MysqlClient < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/9.3/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-9.3/mysql-9.3.0.tar.gz"
  sha256 "1a3ee236f1daac5ef897c6325c9b0e0aae486389be1b8001deb3ff77ce682d60"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "975fd82ddc975521c79adc5b8d91c8fe739e2d4b4f2f7716bb52dfaad32cd8cb"
    sha256 arm64_sonoma:  "b0f29c9fbf56dd9f36ba0518e6a08fcedd7cf39884a2828a34e3c1b69cf5ac5d"
    sha256 arm64_ventura: "20d77f2b858872d0fdfdddc552d0f0c513bdc4e939bfe43eea57a6b47fb7070d"
    sha256 sonoma:        "418c9c100877a4dae7dd49b6e78c1aafb0db23bcddbf94e522e39a78c8130398"
    sha256 ventura:       "3529c333d6cc9ca4925f0297a4ed70cf5d41bbcdb3d45dfee4a81bd16b56a8e7"
    sha256 arm64_linux:   "b7cb2de7878be31f6896f08617393a83d836620192ad20649361c101a48b591f"
    sha256 x86_64_linux:  "b19afb43de7e7a05235af8abbabec78a12fddac8278079d449cda6824683205e"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
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
