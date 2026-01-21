class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.45.tar.gz"
  sha256 "f679707d05f0c2b61e9b14961302e7f540c23e9e5e2bffd8ad9193599e295cee"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  bottle do
    sha256 arm64_tahoe:   "e64173ee56c31739134cd06df27f4590f970b336b8584b6809746890d07659b7"
    sha256 arm64_sequoia: "06d29c681212f7f7ccdc8aecb8ca436344cf8ce1dc76d0faab11b9a7d15ef39b"
    sha256 arm64_sonoma:  "ea81b8fd4dc4dff70258bfed613c2314ffa2627ed7041fbb5a5acbfcc87cb090"
    sha256 sonoma:        "23f362f731daf2989cb506994fcb69d5d0e52b71770fa06f4e2adb80e5d5d0cb"
    sha256 arm64_linux:   "16912c662fb071e209bfa44de3ab0ebf26967a861fcdfd6a77df90f0bb7f5540"
    sha256 x86_64_linux:  "f9f8b84a8fff348c2a215ffd5d25a7aaeb67b9f0b881ba67532427c7bb7993ab"
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
