class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/releases/download/3.1.12/MySQL-Sandbox-3.1.12.tar.gz"
  sha256 "1dd7eada1bf05d297c63a3c16c41183801d792393b850e4059a828841fbd5b38"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c7d4ecf66a5e11ad83527e5cc1496bc3f57333f9ea57bb9f5c6f13d71e81158" => :el_capitan
    sha256 "c7d65ae081e2f0f571640d7616e9705f003522a9aa40bfbb2ff38d7919a5c495" => :yosemite
    sha256 "7367d5179e6e03c766e330955c6b2d2f5b4ffc83d674a43d22e5dd1e968e11a7" => :mavericks
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
