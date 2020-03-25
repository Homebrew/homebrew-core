class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.1.0/source/tarball/percona-toolkit-3.1.0.tar.gz"
  sha256 "722593773825efe7626ff0b74de6a2133483c9c89fd7812bfe440edaacaec9cc"
  revision 2
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    sha256 "12db01f1fa8f1f2d9dbce405dcd84f61e94ec47466bb33a9b167e3f0c4ad2133" => :catalina
    sha256 "aba147044860a0b45f6dcac78856942f1f633af6aa748f59f443678b566248c8" => :mojave
    sha256 "ab0ad14f2a7b9acc5aa43e798ed1605381aad0a4ff87d02ca963403231ac1c12" => :high_sierra
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
    bin.find do |f|
      next unless f.file?
      next unless f.read("#!/usr/bin/env perl".length) == "#!/usr/bin/env perl"

      inreplace f, "#!/usr/bin/env perl", "#!/usr/bin/perl"
    end

    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp
  end
end
