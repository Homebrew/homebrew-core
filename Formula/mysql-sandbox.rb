class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.10.tar.gz"
  sha256 "a1162cdf4b9b54647de79253c9a1ecc2a5a83e5c0c8b318aeb3b77ec6b832511"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e41e49bb52dee038f4b4f7106ca60610ea1569ff1fb383cf0201463bda2e0202" => :sierra
    sha256 "2ac770766ecdc5eb8d373d5ca9db7f370ef03a95d0f00063332e58d1b30d12c7" => :el_capitan
    sha256 "b26f7b2f7bddafa61e81d54bd650e4363f8118448448a3ad114ee22e10274dd2" => :yosemite
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
