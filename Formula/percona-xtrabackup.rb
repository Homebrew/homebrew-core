class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.8/source/tarball/percona-xtrabackup-2.4.8.tar.gz"
  sha256 "66a9cb73ce03c8a0b125998d464190288cb400cc6c22a766798ed4b24cceab91"

  bottle do
    sha256 "7f97be597d718e5e906fd39af2cfda61be6a8c50ac1ad06d70c3deb92d3bdf94" => :sierra
    sha256 "ba9094df79677eb0923b70013be2ec96266b9af2fb93b50923a7ec6603475acd" => :el_capitan
    sha256 "388f6608b8f0577c9bc2f603021c3f7985a9a4c0f5ba21b21a2feb3fbdc22d24" => :yosemite
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
    url "https://cpan.metacpan.org/authors/id/M/MI/MICHIELB/DBD-mysql-4.043.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MI/MICHIELB/DBD-mysql-4.043.tar.gz"
    sha256 "629f865e8317f52602b2f2efd2b688002903d2e4bbcba5427cb6188b043d6f99"
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
    assert_match version.to_s, shell_output("#{bin}/xtrabackup --version 2>&1")
  end
end
