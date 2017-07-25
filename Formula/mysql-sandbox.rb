class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.13.tar.gz"
  sha256 "7ca26ead041f3808f9492bd4ad7fae49cfbda7f7818f5fcb004c14e6ef8cc57e"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2601cbd74c2824c751cd7ce25218801e70e8c48b289c11d4ee4eac669229181b" => :sierra
    sha256 "a2dec757df0f82d0c29e2298f03b83079b3bb8cbe1beeab99f34c782a2a30ddb" => :el_capitan
    sha256 "fd1b3380e6f086dd3e06d88e941e0e12d59a6a592b4ef18255a4ac3e674d957c" => :yosemite
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
