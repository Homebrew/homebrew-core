# This is an exception to Homebrew's CPAN formula policy due to the workarounds
# needed to use macOS DBI and to avoid overlinking to libraries like `zlib`.
class PerlDbdMysql < Formula
  desc "MySQL driver for the Perl5 Database Interface (DBI)"
  homepage "https://dbi.perl.org/"
  url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-5.013.tar.gz"
  sha256 "aeb0a6e1c26fc28a5cf6de1161e0f056ddcbb739f87954dba7cb1c5acb4e1c33"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 2
  compatibility_version 1
  head "https://github.com/perl5-dbi/DBD-mysql.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "722a4fe1171da879885f2153bbf3a6100070663c002f0b2b0421c9d653294c06"
    sha256 cellar: :any, arm64_sequoia: "769dca01680b8dd122820f8c4b26614c621fbf2525ff6732372bfd4a55ae9f14"
    sha256 cellar: :any, arm64_sonoma:  "e08cef78e2659e0cb1ba664602ab5f89ed8c6ffb4cf228a901561cad028a0f92"
    sha256 cellar: :any, sonoma:        "04048bde5e19f835d7d5db7f4d95e14f2a6290e25b71495953e3b188d2224a4c"
    sha256 cellar: :any, arm64_linux:   "1896b31b7903fb882cb84e9a74baa978e38dff5058f1d83f60ec197df7f7ce22"
    sha256 cellar: :any, x86_64_linux:  "32b7e598696ac82933ebc27bd98d830e12dd045e7c1daef816bc81124b8d2953"
  end

  keg_only <<~EOS
    it is mainly used internally by other formulae.
    Users are advised to use `cpan` to install DBD::mysql
  EOS

  depends_on "mysql" => :test
  depends_on "mysql-client"

  uses_from_macos "perl"

  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "DBI" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/DBI-1.647.tgz"
      sha256 "0df16af8e5b3225a68b7b592ab531004ddb35a9682b50300ce50174ad867d9aa"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        install_base = (r.name == "Devel::CheckLib") ? buildpath/"build_deps" : libexec
        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}", "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"

    make_args = []
    if OS.mac?
      # Reduce overlinking on macOS
      make_args << "OTHERLDFLAGS=-Wl,-dead_strip_dylibs"
      # Work around macOS DBI generating broken Makefile
      inreplace "Makefile" do |s|
        old_dbi_instarch_dir = s.get_make_var("DBI_INSTARCH_DIR")
        new_dbi_instarch_dir = "#{MacOS.sdk_path}#{old_dbi_instarch_dir}"
        s.change_make_var! "DBI_INSTARCH_DIR", new_dbi_instarch_dir
        s.gsub! " #{old_dbi_instarch_dir}/Driver_xst.h", " #{new_dbi_instarch_dir}/Driver_xst.h"
      end
    end

    system "make", "install", *make_args
  end

  test do
    perl = OS.mac? ? "/usr/bin/perl" : Formula["perl"].bin/"perl"
    port = free_port
    socket = testpath/"mysql.sock"
    mysql = Formula["mysql"]
    mysqld_args = %W[
      --no-defaults
      --mysqlx=OFF
      --user=#{ENV["USER"]}
      --port=#{port}
      --socket=#{socket}
      --basedir=#{mysql.prefix}
      --datadir=#{testpath}/mysql
      --tmpdir=#{testpath}/tmp
    ]

    (testpath/"mysql").mkpath
    (testpath/"tmp").mkpath
    (testpath/"test.pl").write <<~PERL
      use strict;
      use warnings;
      use DBI;
      my $dbh = DBI->connect("DBI:mysql:;port=#{port};mysql_socket=#{socket}", "root", "", {'RaiseError' => 1});
      $dbh->do("CREATE DATABASE test");
      $dbh->do("CREATE TABLE test.foo (id INTEGER, name VARCHAR(20))");
      $dbh->do("INSERT INTO test.foo VALUES (1, " . $dbh->quote("Tim") . ")");
      $dbh->do("INSERT INTO test.foo VALUES (?, ?)", undef, 2, "Jochen");
      my $sth = $dbh->prepare("SELECT * FROM test.foo");
      $sth->execute();
      while (my $ref = $sth->fetchrow_hashref()) {
        print "$ref->{'id'},$ref->{'name'}\\n";
      }
      $sth->finish();
      $dbh->disconnect();
    PERL

    system mysql.bin/"mysqld", *mysqld_args, "--initialize-insecure"
    pid = spawn(mysql.bin/"mysqld", *mysqld_args)
    with_env(PERL5LIB: libexec/"lib/perl5") do
      sleep 5
      assert_equal "1,Tim\n2,Jochen\n", shell_output("#{perl} test.pl")
    ensure
      system mysql.bin/"mysqladmin", "--port=#{port}", "--socket=#{socket}", "--user=root", "--password=", "shutdown"
      Process.kill "TERM", pid
    end
  end
end
