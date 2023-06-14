class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://downloads.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.32-26/source/tarball/percona-xtrabackup-8.0.32-26.tar.gz"
  sha256 "2a1c23497ffd5905d6dc20bdb5a801d1b8baeb3245ec11ed115dee0d78b7a5e2"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url "https://www.percona.com/downloads/Percona-XtraBackup-LATEST/"
    regex(/value=.*?Percona-XtraBackup[._-]v?(\d+(?:\.\d+)+-\d+)["' >]/i)
  end

  bottle do
    sha256 arm64_ventura:  "773fe388c6889bd73c9bc9e4f1d7412ecc5275e8be206784e8516fa840852d8a"
    sha256 arm64_monterey: "a08039d4a3e0c5ea1ae17b23769f8e2ead1798669fd8fff1b91e4356f11297bb"
    sha256 arm64_big_sur:  "3638453f0c6cedec4953ab325480f15805b215c2bfddf3a3c7d0ca5facb90a60"
    sha256 ventura:        "4a12748dbff1f7766d5ab717384961b35a1580307dda71ac1853187a349a299c"
    sha256 monterey:       "0466a6a332683d146a316a174dd21dbcde2c657eefe8bc30e3c5ef03d9b4d3a0"
    sha256 big_sur:        "826b289bdc606752354383079e7664f97134928693d35d9f2919a039c621d466"
    sha256 x86_64_linux:   "29af2876a9ec091f4e03fb045b12cfb23647a5d50d8546c56cb4dbd1fa7f43af"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "icu4c"
  depends_on "libev"
  depends_on "libevent"
  depends_on "libfido2"
  depends_on "libgcrypt"
  depends_on "lz4"
  depends_on "mysql"
  depends_on "openssl@1.1"
  depends_on "protobuf@21"
  depends_on "zstd"

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libaio"
    # Incompatable with procps-4 https://jira.percona.com/browse/PXB-2993
    depends_on "procps@3"
  end

  conflicts_with "percona-server", because: "both install a `kmip.h`"

  fails_with :gcc do
    version "6"
    cause "The build requires GCC 7.1 or later."
  end

  # Should be installed before DBD::mysql
  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.14.tar.gz"
    sha256 "f21c5e299ad3ce0fdc0cb0f41378dca85a70e8d6c9a7599f0e56a957200ec294"
  end

  # This is not part of the system Perl on Linux and on macOS since Mojave
  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-4.050.tar.gz"
    sha256 "4f48541ff15a0a7405f76adc10f81627c33996fbf56c95c26c094444c0928d78"
  end

  # https://github.com/percona/percona-xtrabackup/blob/percona-xtrabackup-#{version}/cmake/boost.cmake
  resource "boost" do
    url "https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.tar.bz2"
    sha256 "fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854"
  end

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https://github.com/Homebrew/homebrew-test-bot/pull/820
  # Re-using variant from mysql
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/030f7433e89376ffcff836bb68b3903ab90f9cdc/mysql/boost-check.patch"
    sha256 "af27e4b82c84f958f91404a9661e999ccd1742f57853978d8baec2f993b51153"
  end

  def install
    # Disable ABI checking
    inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    cmake_args = %W[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_PLUGINDIR=lib/percona-xtrabackup/plugin
      -DINSTALL_MANDIR=share/man
      -DWITH_MAN_PAGES=ON
      -DINSTALL_MYSQLTESTDIR=
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_ICU=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
    ]

    (buildpath/"boost").install resource("boost")
    cmake_args << "-DWITH_BOOST=#{buildpath}/boost"

    # Remove conflicting manpages
    rm (Dir["man/*"] - ["man/CMakeLists.txt"])

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # remove conflicting library that is already installed by mysql
    rm lib/"libmysqlservices.a"

    ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"

    resource("Devel::CheckLib").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}/build_deps"
      system "make", "install"
    end

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # This is not part of the system Perl on Linux and on macOS since Mojave
    if OS.linux? || MacOS.version >= :mojave
      resource("DBI").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    bin.env_script_all_files(libexec/"bin", PERL5LIB: libexec/"lib/perl5")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xtrabackup --version 2>&1")

    mkdir "backup"
    output = shell_output("#{bin}/xtrabackup --target-dir=backup --backup 2>&1", 1)
    assert_match "Failed to connect to MySQL server", output
  end
end
