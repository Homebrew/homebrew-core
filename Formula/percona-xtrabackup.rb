class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://www.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.25-17/source/tarball/percona-xtrabackup-8.0.25-17.tar.gz"
  sha256 "9f59d6d6a781043291c69c1a14e888f64b32ad95bead2eafc2940e3d984793df"

  livecheck do
    url "https://www.percona.com/downloads/Percona-XtraBackup-LATEST/"
    regex(/value=.*?Percona-XtraBackup[._-]v?(\d+(?:\.\d+)+-\d+)["' >]/i)
  end

  bottle do
    sha256 arm64_big_sur: "f37f29f4e54c87c68809b3b21caf3764ed97180c729fa8a7e116275e8a0b492d"
    sha256 big_sur:       "a2fde831a45845367f31dd064937839776364c9e363f729652d0e9acce70153a"
    sha256 catalina:      "a5523f5a64e0a226c255dfd1c7d94deac6612f21fe05976295225752dba3da3f"
    sha256 mojave:        "f233229c815dda2cc223de08a68c3932afb6ed289b1da7ceaa0262673552332e"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build
  depends_on "icu4c"
  depends_on "libev"
  depends_on "libevent"
  depends_on "libgcrypt"
  depends_on "lz4"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  # Should be installed before DBD::mysql
  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.14.tar.gz"
    sha256 "f21c5e299ad3ce0fdc0cb0f41378dca85a70e8d6c9a7599f0e56a957200ec294"
  end

  # In Mojave, this is not part of the system Perl anymore
  if MacOS.version >= :mojave
    resource "DBI" do
      url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
      sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
    end
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-4.050.tar.gz"
    sha256 "4f48541ff15a0a7405f76adc10f81627c33996fbf56c95c26c094444c0928d78"
  end

  # https://github.com/percona/percona-xtrabackup/blob/percona-xtrabackup-#{version}/cmake/boost.cmake
  resource "boost" do
    url "https://boostorg.jfrog.io/artifactory/main/release/1.73.0/source/boost_1_73_0.tar.bz2"
    sha256 "4eb3b8d442b426dc35346235c8733b5ae35ba431690e38c6a8263dce9fcbb402"
  end

  def install
    cmake_args = %W[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_PLUGINDIR=lib/percona-xtrabackup/plugin
      -DINSTALL_MANDIR=share/man
      -DWITH_MAN_PAGES=ON
      -DINSTALL_MYSQLTESTDIR=
      -DWITH_EDITLINE=system
      -DWITH_ICU=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=#{Formula["openssl@1.1"].opt_prefix}
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
    ]

    # macOS has this value empty by default.
    # See https://bugs.python.org/issue18378#msg215215
    ENV["LC_ALL"] = "en_US.UTF-8"

    (buildpath/"boost").install resource("boost")
    cmake_args << "-DWITH_BOOST=#{buildpath}/boost"

    cmake_args.concat std_cmake_args

    # Remove conflicting manpages
    rm (Dir["man/*"] - ["man/CMakeLists.txt"])

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
    end

    # remove conflicting library that is already installed by mysql
    rm lib/"libmysqlservices.a"

    on_macos do
      # Remove libssl copies as the binaries use the keg anyway and they create problems for other applications
      rm lib/"libssl.dylib"
      rm lib/"libssl.1.1.dylib"
      rm lib/"libcrypto.1.1.dylib"
      rm lib/"libcrypto.dylib"
    end

    ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"

    resource("Devel::CheckLib").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}/build_deps"
      system "make", "install"
    end

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # In Mojave, this is not part of the system Perl anymore
    if MacOS.version >= :mojave
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
