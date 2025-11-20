class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.44.tar.gz"
  sha256 "a8cc09a35af63668c5235cf282aef789428c6f30c1d9a581b337c816ce8ce8bb"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "1065b0a682a05461705bb1fd5d58fdf09d73d7c31f4c8aec2c6b5a45eb2bd4f0"
    sha256 arm64_sequoia: "5320a6b0c5c6439ca6318e554d021b24922f0e544fb2b53d2a86095bf11ed741"
    sha256 arm64_sonoma:  "5fce645ea15e4a39c028889fc83e8b57228273b9a209872d6f5dd10836d93896"
    sha256 sonoma:        "92587c24f9e4e9c30ec415110409e2ae3941e969d4c29022aa9b2663ba4a8157"
    sha256 arm64_linux:   "ebeb66a4fe8c60078b9765c4e052cd98c3b5054f3ef498f27328b7b092a50b1e"
    sha256 x86_64_linux:  "47982089ccbe5051199874e4c3fb760ef3cce1dae7e852585bc1211c9bff4a8b"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libfido2"
  depends_on "openssl@3"
  depends_on "zlib" # Zlib 1.2.13+
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
