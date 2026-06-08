class MysqlClientAT84 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.4/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.9.tar.gz"
  sha256 "e4aa8b39e42d1fe078f33bbd73695fac2b54dbc7bb137f0bdbe63f7be1a02d6b"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.4"
  end

  bottle do
    sha256 arm64_tahoe:   "64d1813264a91b765ce22ef535484f75d00202581bd9d3d945af97823153aa2b"
    sha256 arm64_sequoia: "749461b0781cc9bcd8bfebc710c2394c86d3c888ccc61b6983040e9e29896099"
    sha256 arm64_sonoma:  "4742a85b4a6908874afd997bd3a564b1575cfcc118ab8b3f1b160105b12f51fa"
    sha256 sonoma:        "defc32a340919577dca2e59ab5be63e1aac688ca6f76847c41a1d7b326dad02e"
    sha256 arm64_linux:   "9c3f649acef2c317a96d314d3292e633e2d234bd98edf73994f6ebaef16b74d9"
    sha256 x86_64_linux:  "33ad642eebeb777596633b63c017d9df4214b8b3d5139aebe0fca3fe8ee17b86"
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
