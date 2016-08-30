class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.00.tar.gz"
  sha256 "a9b06d13a773a5be544bc113b52517a2e18341e9ace749bd6f3713b85cbaff79"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9455903a6ff6230ef1fd9ad4e68a682a279070456dbd77bbe0cb16ad2a292eca" => :el_capitan
    sha256 "5584c1b21951293307553e2b98383d30ff96165b662914002d5218f00acd553a" => :yosemite
    sha256 "fd5405c7d64a9fb2b459931953eab3333d4c84f87392b1ccd085c1761f40d169" => :mavericks
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
