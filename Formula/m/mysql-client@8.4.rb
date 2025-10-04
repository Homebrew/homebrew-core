class MysqlClientAT84 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.4/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.6.tar.gz"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/mysql-8.4/8.4.6-0ubuntu0.25.04.1/mysql-8.4_8.4.6.orig.tar.gz"
  sha256 "a1e523dc8be96d18a5ade106998661285ca01b6f5b46c08b2654110e40df2fb7"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.4"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "c67e9f0aee957d683b6acc56d327744cc82d9b4d6df5139dfe6328c7ffc7a340"
    sha256 arm64_sequoia: "3609f27603e56597c351bafb2ec87e78056d3c186bdd28d3de28bf302cc10c4d"
    sha256 arm64_sonoma:  "345d4f8422c0c0561fafaed5f3132c4441ae4a2ddc8609ebf255c72fbe4f189d"
    sha256 arm64_ventura: "d23e3b5c7933bbadb7121fe582ff41e72061cd82e4190fa73b60f00368112243"
    sha256 sonoma:        "3b4aa44856ffde2273d737a3f4f94d0a8f223e7b3597a95859925775f98c536a"
    sha256 ventura:       "021790fb2b3a1b6edd7fcafefed1f880648c16cd4aee11ebe5d4388944df63a2"
    sha256 arm64_linux:   "db8a67e3891f055a77fd3d1ca24c2c0feb1a745335fd10a317eb71e9daffc3d9"
    sha256 x86_64_linux:  "d8fc1af041673df854a2e07edd06603bd88be7a1cce38135a93b320b8e5de973"
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
