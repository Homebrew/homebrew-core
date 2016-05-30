class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.2/source/tarball/percona-xtrabackup-2.4.2.tar.gz"
  sha256 "faeac6f1db4a1270e5263e48c8a94cc5c81c772fdea36879d1be18dcbcd1926e"
  revision 1

  bottle do
    sha256 "21f50e161b66679564cd0b9e43a59b74cd46dbfd4d36bd056c0649af3a310766" => :el_capitan
    sha256 "0748d6439e8305471d76279cb64ddff7c94e0c0921f23dd25b7efcb487b97509" => :yosemite
    sha256 "368b7274e4b82a98f8dc2998b5741fbb484655a1e075f975d48b4600e7385ade" => :mavericks
  end

  option "without-docs", "Build without man pages (which requires python-sphinx)"
  option "without-mysql", "Build without bundled Perl DBD::mysql module, to use the database of your choice."

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on :mysql => :recommended
  depends_on "libev"
  depends_on "libgcrypt"
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    sha256 "cc98bbcc33581fbc55b42ae681c6946b70a26f549b3c64466740dfe9a7eac91c"
  end

  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
    sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"
  end

  def install
    cmake_args = %W[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
    ]

    if build.with? "docs"
      cmake_args.concat %W[
        -DWITH_MAN_PAGES=ON
        -DINSTALL_MANDIR=share/man
      ]

      # OSX has this value empty by default.
      # See https://bugs.python.org/issue18378#msg215215
      ENV["LC_ALL"] = "en_US.UTF-8"
    else
      cmake_args << "-DWITH_MAN_PAGES=OFF"
    end

    # 1.59.0 specifically required. Detailed in cmake/boost.cmake
    (buildpath/"boost_1_59_0").install resource("boost")
    cmake_args << "-DWITH_BOOST=#{buildpath}/boost_1_59_0"

    cmake_args.concat std_cmake_args

    system "cmake", *cmake_args
    system "make"
    system "make", "install"

    share.install "share/man" if build.with? "docs"

    rm_rf prefix/"xtrabackup-test" # Remove unnecessary files

    if build.with? "mysql"
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resource("DBD::mysql").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
      bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    system "#{bin}/xtrabackup", "--version"
  end
end
