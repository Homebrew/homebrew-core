# This is an exception to Homebrew's CPAN formula policy due to the workarounds
# needed to use macOS DBI and to avoid overlinking to libraries like `zlib`.
class PerlDbdMysql < Formula
  desc "MySQL driver for the Perl5 Database Interface (DBI)"
  homepage "https://dbi.perl.org/"
  url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-5.012.tar.gz"
  sha256 "f54ad1bb7ae167e26cd557b5e1b87f7fa49c1dd126f3523eaace6e5c19dbaf46"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/perl5-dbi/DBD-mysql.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a818c34194b7033c3468ec5d901cdbf66afe40d5a4efccb7d634eecd773b0677"
    sha256 cellar: :any,                 arm64_sonoma:  "377d85c6b652c4e94befb922f6cbe3a4736306b1e8c5846a6bf8e4d6cfa6d7b6"
    sha256 cellar: :any,                 arm64_ventura: "51d1372055361e144df670899db7e349a6b044050ac6857ab7c02930865f3647"
    sha256 cellar: :any,                 sonoma:        "6107ea139da53c0a82292c9df4f44b499715893afefd7fb9eab6479b87c2d3f8"
    sha256 cellar: :any,                 ventura:       "53036da34b010da8aae2779c40af2ab50f74af7a4e4efeb49c3600d754d47ca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b2557186487224db79a8dc207eed88e1f6d309f585d7056c8b40770442daa20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639203685dc517e9960efaa4a3bfe8004456627ba79f2328d6034c48cc1e0710"
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
        new_dbi_instarch_dir = "#{MacOS.sdk_path_if_needed}#{old_dbi_instarch_dir}"
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
