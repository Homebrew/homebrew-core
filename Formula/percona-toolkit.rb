class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.13/source/tarball/percona-toolkit-3.0.13.tar.gz"
  sha256 "21f68d1c5204a9cad7be716fd1e53f0fe6ff7d995292b56dbc7c55e3979432b1"
  revision 1
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "1a4d81c900166778aaacd7d3229f44ee50b0fa459c29de79b46b623041ba3bd6" => :catalina
    sha256 "a4bad18fddbba29c052142b2f2ab78b4172915ec3ce6ccdd25f37e417d4e3b55" => :mojave
    sha256 "9825bfde46b669fd79a189ce075d34b5654fdc1743c3cac0fd7366288db7a007" => :high_sierra
    sha256 "86253e327592de79373eb010fc134dfdbc2e68ab2a222dbdb3ed176e65243cbd" => :sierra
  end

  depends_on "mysql-client"
  depends_on "openssl@1.1"

  # In Mojave, this is not part of the system Perl anymore
  if MacOS.version >= :mojave
    resource "DBI" do
      url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.642.tar.gz"
      sha256 "3f2025023a56286cebd15cb495e36ccd9b456c3cc229bf2ce1f69e9ebfc27f5d"
    end
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.00.tar.gz"
    sha256 "c4da1f1075878604b7b1f085ff3963e1073ed1c603c3bc9f0b0591e3831a1068"
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
