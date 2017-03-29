class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/2.2.20/tarball/percona-toolkit-2.2.20.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/percona-toolkit/percona-toolkit_2.2.20.orig.tar.gz"
  sha256 "8439be616ee43b22ba7526135719ef6f40af6621327acc30b84be5f18cd426b1"
  head "lp:percona-toolkit", :using => :bzr

  bottle :disable, "To use the user's database of choice."

  depends_on :mysql
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MICHIELB/DBD-mysql-4.042.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MI/MICHIELB/DBD-mysql-4.042.tar.gz"
    sha256 "dadb6884788dc3fdf40b13b72d8c60d5a83680cc2aeec7515c3e5999e064b455"
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
