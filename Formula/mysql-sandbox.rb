class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.00.tar.gz"
  sha256 "a9b06d13a773a5be544bc113b52517a2e18341e9ace749bd6f3713b85cbaff79"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "64035c68f186826da58b7c5960589e472cb3a9a87c0708ec3f66851a4a51216c" => :el_capitan
    sha256 "e7523eabf61bcd519c1d7d7faa7c28d28c562bb946594c37f6e1a22c2138a9d6" => :yosemite
    sha256 "226208df982aa899b9835cf8938d40151d4e8256392098aba057b4211299f167" => :mavericks
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
