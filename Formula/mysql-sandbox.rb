class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/releases/download/3.1.08/MySQL-Sandbox-3.1.08.tar.gz"
  sha256 "24e48bcd44370160214895b1594182605f5cd2f775cfa6c09325564efacd3366"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31dfeb21dbeb8c7f74437ba650130334c1bdb29f96c8667f9639ad63b02e0488" => :el_capitan
    sha256 "a397444221a5198a6f3aaeef1035ba6fa016a863ea468eb0b6a965a9c88ac6d6" => :yosemite
    sha256 "218a6a823fceb247cc95fe601c0a95ad84039f86a17e738801955fb9e30e6fdf" => :mavericks
  end

  def install
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5/site_perl/"

    system "perl", "Makefile.PL", "PREFIX=#{libexec}"
    system "make", "test", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/msandbox", 1)
  end
end
