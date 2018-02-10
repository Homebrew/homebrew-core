class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.6/source/tarball/percona-toolkit-3.0.6.tar.gz"
  sha256 "02a978dd61fe282cae42afb92ed7da585d6e5c9b6f0c1ca57272b378a004f365"
  revision 1

  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "f4d7b44859ef9add3095b14a541007747c477001b73a5ae4d8d5436aeae0877e" => :high_sierra
    sha256 "9e3601d932eb9a012c648bed73a9d01e886f96d709e51993fe2b188aa0e6ebf2" => :sierra
    sha256 "f5199f52b1428b8a7f1086d9e7ba8f6a1279817997dcc694557c31f9888dce52" => :el_capitan
  end

  depends_on "mysql"
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-2.97001.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/I/IS/ISHIGAKI/JSON-2.97001.tar.gz"
    sha256 "e277d9385633574923f48c297e1b8acad3170c69fa590e31fa466040fc6f8f5a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "test", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp
  end
end
