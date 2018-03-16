class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.7/source/tarball/percona-toolkit-3.0.7.tar.gz"
  sha256 "40f1a2241fb3ac1049e43ea75056f02d8af48c1eb731b48a4b564a054f8227e3"
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "c29f188515733b37e205ef3784593abd9c1b5d573ebbc4e682bf0cf86253bad8" => :high_sierra
    sha256 "61f3da20a55546c69c3654f6a7655399eb8016b5f6bc65ff5e04aadf050175f9" => :sierra
    sha256 "5e473591e46fe26e157c9c5c559f2478eb3d27b9c20034ef524232db794b50ee" => :el_capitan
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
