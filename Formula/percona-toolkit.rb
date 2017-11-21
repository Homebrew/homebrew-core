class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.5/source/tarball/percona-toolkit-3.0.5.tar.gz"
  sha256 "6ca8dd50fcff8a6030026201a5224bd3446d66c2c2ce484dc5c4cfae359c955b"
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "77aa3723b88f855b37e6c0676237a6644f3bb70ecf9cbb0f878522694e8be463" => :high_sierra
    sha256 "a9841215e8be6769718ba5cc9a7d64f7acb473f4a29309236bb8e2082bc1f634" => :sierra
    sha256 "ab892ddb81ae7ef729ab6a9d877d0902aebedebfcafb254ffc66a25780de085c" => :el_capitan
    sha256 "cd53523240673a8db3180c45907aaae5d81067fb59f3f66fe35030671a942223" => :yosemite
  end

  depends_on :mysql
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
