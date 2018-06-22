class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.12/source/tarball/percona-xtrabackup-2.4.12.tar.gz"
  sha256 "de02cfd5bde96ddbf50339ef3a4646004dde52239698df45c19ed3e8ee40738e"

  bottle do
    sha256 "16790b0fb43e56bb08e0ef5a6afe74dac2be6607d7b7fdddf0ee443b1e89c11d" => :high_sierra
    sha256 "4e78194dc3d7de6ced30cad8c0666e9a8c1a891f9187107c5b722d3f55d3cd3d" => :sierra
    sha256 "9ac22fa346e623bbed78d55fc768ce576414d1ef95f23905ca26ca766910e7e8" => :el_capitan
  end

  option "without-docs", "Build without man pages (which requires python-sphinx)"
  option "without-mysql-client", "Build without bundled Perl DBD::mysql module, to use the database of your choice."

  deprecated_option "without-mysql" => "without-mysql-client"

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "mysql-client" => :recommended
  depends_on "libev"
  depends_on "libgcrypt"
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
    sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"
  end

  def install
    cmake_args = %w[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
    ]

    if build.with? "docs"
      cmake_args.concat %w[
        -DWITH_MAN_PAGES=ON
        -DINSTALL_MANDIR=share/man
      ]

      # macOS has this value empty by default.
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
    # remove conflicting libraries that are already installed by mysql
    rm lib/"libmysqlservices.a"
    rm lib/"plugin/keyring_file.so"

    if build.with? "mysql-client"
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resource("DBD::mysql").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
      bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xtrabackup --version 2>&1")
  end
end
