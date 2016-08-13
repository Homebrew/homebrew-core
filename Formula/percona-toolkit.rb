class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/2.2.18/tarball/percona-toolkit-2.2.18.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/percona-toolkit/percona-toolkit_2.2.18.orig.tar.gz"
  sha256 "62f6bab6ed4a57259b86a5ccbcc5ced8d37f22d06ed18a0508314a7d1c7e19f5"
  revision 1

  head "lp:percona-toolkit", :using => :bzr

  bottle :disable, "To use the user's database of choice."

  depends_on :mysql
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MICHIELB/DBD-mysql-4.035.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MI/MICHIELB/DBD-mysql-4.035.tar.gz"
    sha256 "b7eca365ea16bcf4c96c2fc0221304ff9c4995e7a551886837804a8f66b61937"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    sha256 "4ddbb3cb985a79f69a34e7c26cde1c81120d03487e87366f9a119f90f7bdfe88"
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
    system bin/"pt-summary"
  end
end
