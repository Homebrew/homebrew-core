class MysqlClient < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/9.3/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-9.4/mysql-9.4.0.tar.gz"
  mirror "https://repo.mysql.com/apt/ubuntu/pool/mysql-innovation/m/mysql-community/mysql-community_9.4.0.orig.tar.gz"
  sha256 "6bb509c54e58b54abbefa49e296e7220f5e7cfe446914ba3615f594967cfa921"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "de5ef34d0a35a5e2458c46e3e8679da656d8ba21e84ff32a6e054c662b218f75"
    sha256 arm64_sequoia: "8df3287c752bbc87c18699ede1268b02cefbe9d8e412f4ffc3e28c9439b9363b"
    sha256 arm64_sonoma:  "7bd0ccacb8e870116bd8ea64d5e0df32b88e463ac4b8f7b1dc95b0aa296f1ddc"
    sha256 arm64_ventura: "67e048397b2f14197d0aed67065ff52114d0d2207e0c723ff121512ccd60a094"
    sha256 sonoma:        "056b6956d2f13d06f6a094c9c9674643a7b07069b80936c33d73e882561ee826"
    sha256 ventura:       "3442cade080da8ad821e9ca521cb012dbe397c6f4cc84cf544e1b928b7ab685a"
    sha256 arm64_linux:   "af4a826e700ef6fc6b08b07441dc2fe6ef31612aaa8a100a41df3b17745c6982"
    sha256 x86_64_linux:  "ccc0316df77bab8dfcf093c455b671256b4aaa6e44bee0a93521c89f04523e0a"
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
