class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/releases/download/3.1.12/MySQL-Sandbox-3.1.12.tar.gz"
  sha256 "1dd7eada1bf05d297c63a3c16c41183801d792393b850e4059a828841fbd5b38"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8b113a462ea308b6bdf47a238be11313363165c62a91f8fc038410957ef2f14" => :el_capitan
    sha256 "c1da616b42545a0e5a2abd235f9d3cc0c32785889c670452d7c3beb55743c931" => :yosemite
    sha256 "8f354abd2c8d4f0e441658bc11945ee3ebfca869d01d018647ba76f69a94ee3e" => :mavericks
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
