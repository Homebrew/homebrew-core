class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.12/source/tarball/percona-toolkit-3.0.12.tar.gz"
  sha256 "7d15d6b186a0fa6e45a1f9c390fab210b1d18f66d24d58b1bea30d2f59b35e20"
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "41f11cadd02f6de1c0a0f92ec9d09d6a8031b29a50a0155098005024aba0434c" => :mojave
    sha256 "e7790d1db85e264098b9be5a8e94846f7ee77c3aac8dcca60304c1efd09f94d0" => :high_sierra
    sha256 "10ccc762d3af04cf387469b305afed1ebbc712ef5176b5ef35a4f03173a22c00" => :sierra
  end

  depends_on "mysql-client"
  depends_on "openssl"

  # In Mojave, this is not part of the system Perl anymore
  if MacOS.version >= :mojave
    resource "DBI" do
      url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.641.tar.gz"
      sha256 "5509e532cdd0e3d91eda550578deaac29e2f008a12b64576e8c261bb92e8c2c1"
    end
  end

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
