class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.08.tar.gz"
  sha256 "f6dbd7965348b8fbc119913a2d4f71aefe99675ba5dcf171d5f4e0b328d0f207"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9287fa6c2f6706b16a87dc48441aa13f966d480161e821e1b83b9e3ed1c9bb70" => :sierra
    sha256 "ea9ba2e8e0a892ddf494f0308c8cbada0cd129c9149446519c0bda0b2dd45477" => :el_capitan
    sha256 "ea9ba2e8e0a892ddf494f0308c8cbada0cd129c9149446519c0bda0b2dd45477" => :yosemite
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
