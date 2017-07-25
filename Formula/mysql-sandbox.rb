class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.13.tar.gz"
  sha256 "7ca26ead041f3808f9492bd4ad7fae49cfbda7f7818f5fcb004c14e6ef8cc57e"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f42a41e9be005bf04a93f475bcdb3602d4210aff5ad195674857723aa99cdd6" => :sierra
    sha256 "777915f49ff7bd70515bfe1892110073e32d4a359399a13f7c7de43242a9f3a1" => :el_capitan
    sha256 "d752173b23f9f2d038134e261b724f5c75d9aedc33ae3d47a012c232e9754057" => :yosemite
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
