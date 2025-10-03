class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.43.tar.gz"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/mysql-8.0/8.0.43-0ubuntu0.24.04.2/mysql-8.0_8.0.43.orig.tar.gz"
  sha256 "85fd5c3ac88884dc5ac4522ce54ad9c11a91f9396fecaa27152c757a3e6e936f"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "9afc22fd13b07efae81fa76ed585e20c5c526d9022b2149a585bd72396775d3f"
    sha256 arm64_sequoia: "bf95e2b85e9d521342fd38c3cb6baf3d694a9325c611e845d4885fb28e2905d0"
    sha256 arm64_sonoma:  "9d250ce8010248c3630079ea802ff8d9fc0e7273b767faa6eda2829415e51a7d"
    sha256 arm64_ventura: "8ce6dd546e38489d6cf9612748110283553946266fd9126297d05fcfcc56fa81"
    sha256 sonoma:        "096755440514b49f7c20551cc2db7d35e3ef38875ba0e282fc923cc31ff3b467"
    sha256 ventura:       "069474c5899799855911c48402afc1ae68c172c374353cff97a54858a2aafc4a"
    sha256 arm64_linux:   "1c126059a852c294a3a114bec1b3ec3a6664d7632af2ee70934189fb97832e97"
    sha256 x86_64_linux:  "d1bdffc6f8b930d3321cb380a7d0354900c0288049752c2dff39770b516e7d51"
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
