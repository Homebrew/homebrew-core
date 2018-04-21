class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.9/source/tarball/percona-toolkit-3.0.9.tar.gz"
  sha256 "1b66fbd0e3427a189980d4c02897da1444ffd2cf40156142728ee7e5cd97be88"
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "80206ccb44f316868b2f2d6c58ce6c3830696114d9775c86849a4c8a69d5956e" => :high_sierra
    sha256 "3e151113cc4c1488ebb4bc09cd87aba8f8093fbfa21193c811a0ebd54e32a946" => :sierra
    sha256 "30e054ecf7a4ca8192389687243380bb4bbaa41fe3cdb5009a96e54a8e17fa29" => :el_capitan
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
