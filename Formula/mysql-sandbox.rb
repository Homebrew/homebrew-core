class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.03.tar.gz"
  sha256 "96b428d803eab6e2d9f630bce9ba7c8f553e335b6dbbed4b091e765392a57285"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fc3f33c0b207c6cdae5b6cc3d7f4d9317fbb00343cec2c6e610f9b4f9b93ea4" => :sierra
    sha256 "a643beb63f10ebb6526adda0c436208986ef28387999341ac8b2e3f44de92d1e" => :el_capitan
    sha256 "b17ffc6a48ab2b5c5f5c543b0769a7812d3752398367e958ae14fd72ab5b1f5c" => :yosemite
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
