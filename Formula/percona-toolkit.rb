class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.6/source/tarball/percona-toolkit-3.0.6.tar.gz"
  sha256 "02a978dd61fe282cae42afb92ed7da585d6e5c9b6f0c1ca57272b378a004f365"
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
    url "https://cpan.metacpan.org/authors/id/M/MI/MICHIELB/DBD-mysql-4.043.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MI/MICHIELB/DBD-mysql-4.043.tar.gz"
    sha256 "629f865e8317f52602b2f2efd2b688002903d2e4bbcba5427cb6188b043d6f99"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-2.94.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/I/IS/ISHIGAKI/JSON-2.94.tar.gz"
    sha256 "12271b5cee49943bbdde430eef58f1fe64ba6561980b22c69585e08fc977dc6d"
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
