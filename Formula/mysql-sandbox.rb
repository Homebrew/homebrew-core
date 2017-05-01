class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.09.tar.gz"
  sha256 "a41f6d375bbecdf465b1b2252e658ac6ae6a2417459dbc905cf4840f998c941a"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "100c05966289927442c13344de62418fa2d32f8c7be18f6fb110a3af7dcedc54" => :sierra
    sha256 "9108192928d844115393b269e5d47c09532c8a87c718682b87dd7fa74d2410fa" => :el_capitan
    sha256 "3f0554af07d732939b2dfdfa3a9ab13afee4f85c2abb5cbf8e12a44ec4d65fad" => :yosemite
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
