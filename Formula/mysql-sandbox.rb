class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.05.tar.gz"
  sha256 "ef500e0561c0ce397334eb5c8af8f1192034af6d2b006efdab3c70ada48a15e8"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c22a52a9ee5eaa338b53c5aee344f8c76eed5f0fcd684f1a6a8d04e1614cd506" => :sierra
    sha256 "17b110152a9440c08be187f2b7f79fcee65a7c07900b4bde0ee2381674d4f6e7" => :el_capitan
    sha256 "6527bdc44e7a256bd20d25df8da1098bb6ebe13379bbd8c0171e2793d7ee2047" => :yosemite
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
