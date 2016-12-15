class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.04.tar.gz"
  sha256 "66992e96a656245ae4c4c891922216f0ddaf733bbd3a7b1bffe310fa677556cc"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ce58f12cc1d315c4cbed1a5c83bd3b529f5cc700aadb083fe6ab4b2f679f6dc" => :sierra
    sha256 "4565932010a033487357c5742b11146e0fa9ebb225a89cf2996c894d877750d9" => :el_capitan
    sha256 "a4e2a293c46d0e4e0eed20ba6b358a073caa520c72721753a9fd8c674ac931a2" => :yosemite
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
