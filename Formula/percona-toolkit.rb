class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.1.0/source/tarball/percona-toolkit-3.1.0.tar.gz"
  sha256 "722593773825efe7626ff0b74de6a2133483c9c89fd7812bfe440edaacaec9cc"
  revision 1
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "d03904f208a454aa020770ff88daacf5358afd7b445b079aee8a9fd30a392a1c" => :catalina
    sha256 "d3d044c5015898fcba816d2dc1cb5d92f4f7263373005c0318970682104bbb69" => :mojave
    sha256 "82c54ae873973d9f1f22217488163ef8d4d4136478f21f72d97854c4fe2ff929" => :high_sierra
  end

  depends_on "mysql-client"
  depends_on "openssl@1.1"

  uses_from_macos "perl"

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
    system "make", "install"
    share.install prefix/"man"

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    # https://github.com/Homebrew/homebrew-core/issues/4936
    non_perl_files = %w[bin/pt-ioprofile bin/pt-mext bin/pt-mysql-summary
                        bin/pt-pmp bin/pt-sift bin/pt-stalk bin/pt-summary]
    perl_files = Dir["bin/*"] - non_perl_files
    inreplace perl_files, "#!/usr/bin/env perl", "#!/usr/bin/perl"

    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp
  end
end
