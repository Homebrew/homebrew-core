class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.9/source/tarball/percona-xtrabackup-2.4.9.tar.gz"
  sha256 "23c1e42ad4161b38edef126cf600e28779788a4d1736cadbb8e8f3dc219135a7"

  bottle do
    sha256 "6f0220b37e6f98774fa56f2caa84288a4a75fd148397426583f18104aafe1afe" => :sierra
    sha256 "ad9ade2be884a20935abe3339102bd790ef2629b99da1da8cf33a375a4fab8d0" => :el_capitan
    sha256 "516832c2921f915955e07cf4833b58e90ee2dad822a5594688a969de347ba5fb" => :yosemite
  end

  option "without-docs", "Build without man pages (which requires python-sphinx)"
  option "without-mysql", "Build without bundled Perl DBD::mysql module, to use the database of your choice."

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "mysql" => :recommended
  depends_on "libev"
  depends_on "libgcrypt"
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
    sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"
  end

  # Fixes compile when building using Clang. Remove on next release.
  patch do
    url "https://github.com/percona/percona-xtrabackup/commit/7862bd714.patch?full_index=1"
    sha256 "5283b069a4a4ddc5771b80c79813118450e8740f6ec7cf88ad5ef1a1da330b96"
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
