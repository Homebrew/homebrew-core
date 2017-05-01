class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.09.tar.gz"
  sha256 "a41f6d375bbecdf465b1b2252e658ac6ae6a2417459dbc905cf4840f998c941a"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af0a6579089ea492e5b3fa4276eb6aa62141b87d3bf27705e37ed79099bca457" => :sierra
    sha256 "271a69ed7be600a368fcd29e7ab9db0042cb0b282611ccb357e3681e78218365" => :el_capitan
    sha256 "647f3b5eb0e0277d31011df28749c89c394de1c89f0856662a82a73464354b67" => :yosemite
  end

  def install
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5/site_perl"

    system "perl", "Makefile.PL", "PREFIX=#{libexec}"
    system "make", "test", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/msandbox", 1)
  end
end
