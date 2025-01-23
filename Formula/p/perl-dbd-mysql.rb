# This is an exception to Homebrew's CPAN formula policy due to the workarounds
# needed to use macOS DBI and to avoid overlinking to libraries like `zlib`.
class PerlDbdMysql < Formula
  desc "MySQL driver for the Perl5 Database Interface (DBI)"
  homepage "https://dbi.perl.org/"
  url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-5.011.tar.gz"
  sha256 "a3a70873ed965b172bff298f285f5d9bbffdcceba73d229b772b4d8b1b3992a1"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/perl5-dbi/DBD-mysql.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "183dd4118c27e2bebe2093168aff319e5ff64a54203a93eb61dc76dd364fce3a"
    sha256 cellar: :any,                 arm64_sonoma:  "8e66e32483e6d64406631fc43b352661d910def183200c8bb1e967b2211ced3d"
    sha256 cellar: :any,                 arm64_ventura: "5856394a6972be37c393c398e37eb562228bd8f395242474578fe5f0163e855c"
    sha256 cellar: :any,                 sonoma:        "8b3cea6ad248e91a4f742699682795bb9bf5ae0fa5fff437b5b028cec230838a"
    sha256 cellar: :any,                 ventura:       "45ea4c402cf8daab4b4d95068563cef1a0938aad685fb17af19a64664b889fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7566a04934048eb35442e588b0d1e45510e3cd5495c7ae383ccc87972a97f060"
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
      url "https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/DBI-1.646.tar.gz"
      sha256 "53ab32ac8c30295a776dde658df22be760936cdca5a3c003a23bda6d829fa184"
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
