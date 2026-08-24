class MysqlClientAT84 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.4/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.11.tar.gz"
  sha256 "eb3051164d625dd346a8203f76e0d5d5d9aec51dbe9d51788e39ec6b3f1394c2"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.4"
  end

  bottle do
    sha256 arm64_tahoe:   "58e87b93a602e9279aab64c7f2116648ac982c5b487010ce4478a3d9c0aa912f"
    sha256 arm64_sequoia: "f969c6eb507a37019a3933b637986e58f17a4b9b011ca04da35e4c83c301e6c3"
    sha256 arm64_sonoma:  "1f5bcd6236d8eabb2635593986d6735baadbfcb0f4821b489c7ce72d6214624f"
    sha256 sonoma:        "32e2a9e69a77bd3826dfb1a790f2bd300b9239d1e25549166a6d15d1171ce825"
    sha256 arm64_linux:   "2b4833fc601c6f814f21ef95d2df92cc6a67b77bbd5066b98e785bbc6f7e8a42"
    sha256 x86_64_linux:  "348a14347341d83c2753ed0ad6a517f2802bcf2b23b4d4f4b9b542fe1cacc858"
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
