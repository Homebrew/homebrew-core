class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.10/source/tarball/percona-toolkit-3.0.10.tar.gz"
  sha256 "ee89aa2a3c5a1a98e234a2564859fb95685838bef72cc76548ddfa62843844d6"
  revision 1
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "727a882ac2702ea83d41a1c2676b201990e7bfc3ac54dffac3a205697edbba43" => :high_sierra
    sha256 "59d011ca358a1a1d8c86f39f1acde1816705d0d2dcd27c33edb2bb142035ca46" => :sierra
    sha256 "eb3455d03e43cbb6207554c739eb848bdd8a3b6b557158247f46ec6d0216dc70" => :el_capitan
  end

  depends_on "mysql-client"
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-2.97001.tar.gz"
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
