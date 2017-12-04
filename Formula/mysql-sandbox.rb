class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.15.tar.gz"
  sha256 "ae702ea708f59e8c37b74b805a4244d3ba30b3314e60f583bcf3585d4cf0cc6a"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4e759b142749603bcd2101e134f0668c08d7bafd8d7a5ee7cce1de50c771f51" => :high_sierra
    sha256 "80bc9ae9480579cf9a96512340557fe1b700767faaebadae771c466d9d46fcf0" => :sierra
    sha256 "5c55955ca9545dc227470a2793054a2c0becb59fa0c2c18012717877deda308a" => :el_capitan
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
