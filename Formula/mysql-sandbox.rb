class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.06.tar.gz"
  sha256 "4da3d493f75f7840cf3df99fb69bd890daf0a8d0c9dcad2cb5af83ac44121eb3"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "120e21232283f75d57af0a31f8efac8f18c9c6a525fcc4e8d6b74e056bd963e4" => :sierra
    sha256 "e98859d123f017ca85bf094b4d2ec6c7d74fe79d65db04dcc2bb14161475e6f5" => :el_capitan
    sha256 "a88d19a4cb4502d709756fd199a0c793c7b31c6f294f604d4bfbf5d8fc827807" => :yosemite
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
