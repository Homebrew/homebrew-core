class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://www.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.13/source/tarball/percona-xtrabackup-8.0.13.tar.gz"
  sha256 "760f556e85ad55bd54019ad78b1064557c68e31b6e37dc4f4ce1f0065b911f71"
  revision 1

  bottle do
    sha256 "054abe5dc28e710b84e6cb46808cb19ea5a031928e321e765d6da5c151ba6209" => :catalina
    sha256 "25301980ab2464084d0f08b24de70e07d2c2b3e3259b16753cdea28eda827d9b" => :mojave
    sha256 "53c2077e8791a0301f923e35f2557fc979a28e2c97c6c47cbdc863decba4c65d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libev"
  depends_on "libgcrypt"
  depends_on "mysql-client"
  depends_on "openssl@1.1"

  conflicts_with "protobuf",
    :because => "both install libprotobuf(-lite) libraries"

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.641.tar.gz"
    sha256 "5509e532cdd0e3d91eda550578deaac29e2f008a12b64576e8c261bb92e8c2c1"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.70.0/boost_1_70_0.tar.bz2"
    sha256 "430ae8354789de4fd19ee52f3b1f739e1fba576f0aded0897c3c2bc00fb38778"
  end

  def install
    cmake_args = %w[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_PLUGINDIR=lib/percona-xtrabackup/plugin
      -DINSTALL_MANDIR=share/man
      -DWITH_MAN_PAGES=ON
      -DINSTALL_MYSQLTESTDIR=
      -DCMAKE_CXX_FLAGS="-DBOOST_NO_CXX11_HDR_ARRAY"
    ]

    # macOS has this value empty by default.
    # See https://bugs.python.org/issue18378#msg215215
    ENV["LC_ALL"] = "en_US.UTF-8"

    # 1.70.0 specifically required. Detailed in cmake/boost.cmake
    (buildpath/"boost_1_70_0").install resource("boost")
    cmake_args << "-DWITH_BOOST=#{buildpath}/boost_1_70_0"

    cmake_args.concat std_cmake_args

    mkdir "build" do
      system "cmake", "..", *cmake_args
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
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xtrabackup --version 2>&1")

    mkdir "backup"
    output = shell_output("#{bin}/xtrabackup --target-dir=backup --backup 2>&1", 1)
    assert_match "Failed to connect to MySQL server", output
  end
end
