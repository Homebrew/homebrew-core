class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.5/source/tarball/percona-toolkit-3.0.5.tar.gz"
  sha256 "6ca8dd50fcff8a6030026201a5224bd3446d66c2c2ce484dc5c4cfae359c955b"
  revision 1
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "fa86aef13448ef63064c7cf23aeb9013227e802f1ff388ced9f4ee01eda8129c" => :high_sierra
    sha256 "989daf0b635c34f685ecb4f5e47071c53c7737df60562fb664c166aac6bedd64" => :sierra
    sha256 "e219a097fdf4fe3b1d304e464f32104b19eed881c74e6ddcbcb692056e715a24" => :el_capitan
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
