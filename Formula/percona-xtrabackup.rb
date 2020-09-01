class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://www.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.14/source/tarball/percona-xtrabackup-8.0.14.tar.gz"
  sha256 "db8d6d2c6a6b016bf24b4942582ebdbd55c09253ccc78daa6911217bd5a73d5d"

  livecheck do
    url "https://github.com/percona/percona-xtrabackup.git"
    regex(/^percona-xtrabackup[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "2f35a444086da15b1e05ec9ac225f153376abb81546db4490fbf34b4096ec6c0" => :catalina
    sha256 "a4f1233ebde9ab66010214fa21c739ae9f97cffcb739bdd51fe542511d5571e1" => :mojave
    sha256 "7238c7d0e4977dcdba034ded3aa5ed9cd71884ba060894060755428aa85ea29a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libev"
  depends_on "libgcrypt"
  depends_on "mysql-client"
  depends_on "openssl@1.1"

  conflicts_with "protobuf",
    because: "both install libprotobuf(-lite) libraries"

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.047.tar.gz"
    sha256 "9a56d1b93a9748c25be6486075a72c416d66f61b8bb6e54492fa6408f2fbb145"
  end

  resource "boost" do
    # 1.72.0 specifically required. Detailed in cmake/boost.cmake
    url "https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz"
    sha256 "c66e88d5786f2ca4dbebb14e06b566fb642a1a6947ad8cc9091f9f445134143f"
  end

  def install
    (buildpath/"boost").install resource("boost")

    args = %W[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_PLUGINDIR=lib/percona-xtrabackup/plugin
      -DINSTALL_MANDIR=share/man
      -DWITH_MAN_PAGES=ON
      -DINSTALL_MYSQLTESTDIR=
      -DCMAKE_CXX_FLAGS="-DBOOST_NO_CXX11_HDR_ARRAY"
      -DWITH_BOOST=#{buildpath}/boost
    ]

    # macOS has this value empty by default.
    # See https://bugs.python.org/issue18378#msg215215
    ENV["LC_ALL"] = "en_US.UTF-8"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end

    # remove conflicting library that is already installed by mysql
    rm lib/"libmysqlservices.a"

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
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xtrabackup --version 2>&1")

    mkdir "backup"
    output = shell_output("#{bin}/xtrabackup --target-dir=backup --backup 2>&1", 1)
    assert_match "Failed to connect to MySQL server", output
  end
end
