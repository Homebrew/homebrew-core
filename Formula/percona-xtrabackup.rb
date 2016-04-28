class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.2/source/tarball/percona-xtrabackup-2.4.2.tar.gz"
  sha256 "faeac6f1db4a1270e5263e48c8a94cc5c81c772fdea36879d1be18dcbcd1926e"

  option "with-docs", "Build man pages"

  depends_on "cmake" => :build
  depends_on "libev" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "libgcrypt"
  depends_on :mysql => :recommended

  def install
    cmake_args = %W[
      -DBUILD_CONFIG=xtrabackup_release
      -DDOWNLOAD_BOOST=1
      -DWITH_BOOST=boost
    ]

    if build.without? "docs"
      cmake_args << "-DWITH_MAN_PAGES=OFF"
    end

    cmake_args.concat std_cmake_args

    system "cmake", *cmake_args
    system "make", "-j4"
    system "make", "install"

    rm_rf prefix/"xtrabackup-test" # Remove unnecessary files
  end

  def caveats; <<-EOS.undent
    You'll need the DBD::mysql Perl module.  To install it
    without modifying OSX's own Perl installation:
    (reopen terminal after each command)

      brew install perl cpanminus
      cpanm DBD::mysql

    EOS
  end

  test do
    system "#{bin}/xtrabackup", "--version"
    system "#{bin}/innobackupex", "--version"
  end
end
