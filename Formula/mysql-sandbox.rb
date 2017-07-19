class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.12.tar.gz"
  sha256 "ac36de83e8c96efe35029ac64486de05ae708fba63f5cc04471e4ecc0a3c7e7f"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7edcdb5b95db5c00cb0f7d1679871e12f15930f60d364417661d063f3e6dfaf" => :sierra
    sha256 "03eb7654668f76c714b64e8fb2436c8f9a3aba98993317732d6ddebee6898860" => :el_capitan
    sha256 "2913a6ebf3a8f13a78b5d6373d2357ae177df3cc71665bf99e638206aa884a34" => :yosemite
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
