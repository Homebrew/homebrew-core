class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.13/source/tarball/percona-toolkit-3.0.13.tar.gz"
  sha256 "21f68d1c5204a9cad7be716fd1e53f0fe6ff7d995292b56dbc7c55e3979432b1"
  revision 1
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "d45ec073ce122e1907529323e0d1efb01b76a1dc8bbdf6d8cf9b9cb59afd8761" => :mojave
    sha256 "c92ffd9b05232537d22150850394abd52cd349f5ee7240afa7a001b7aed421c4" => :high_sierra
    sha256 "aa6bc63cdd8caa0c11aca6034aaf3e013432715923258cd4252d8794a03be951" => :sierra
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
