class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.46.tar.gz"
  sha256 "dff4332ee7f8f37fc0516c66763600a22a81c8192c743c477b6484206e314f2f"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  bottle do
    sha256 arm64_tahoe:   "b04aa085d7b540a2a26910f0adc7eaa82776f4a31c050205877e72dc1b0b14d7"
    sha256 arm64_sequoia: "c62722b6ab50c2608f96655d03136ee76106e30b6ea57e3bd2ed0fa672aa2a96"
    sha256 arm64_sonoma:  "934915d2baa56d43a1f01f7b8e0d982922e03972ce8d690c7a76e47bfc4fb79d"
    sha256 sonoma:        "4aaed2075ded190d1494d60f66a66dfccbe09e3ad0e054043524e953104cf495"
    sha256 arm64_linux:   "73443c2a2c0bc42a5bec2d5f8f110c65cf8cfe952c91dc02cf3db29f8de1fca6"
    sha256 x86_64_linux:  "5b3762f299d424bde333aae29bc00580ed7f52eb0c622887a0222848372fa089"
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
