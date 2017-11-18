class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.15.tar.gz"
  sha256 "ae702ea708f59e8c37b74b805a4244d3ba30b3314e60f583bcf3585d4cf0cc6a"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90b02707caf967fe9b274b7193ba4cc875d29f8a3c1769d0329ec499d1c83f5f" => :high_sierra
    sha256 "3fa11324b9653efb27173bfdde42c821e3494a330eec52c54010edbc1c7d9f03" => :sierra
    sha256 "f613b7d1d5c1d70f5d56147160bc0fc57b5376e99ee708acebd2edaea4a48f22" => :el_capitan
    sha256 "f613b7d1d5c1d70f5d56147160bc0fc57b5376e99ee708acebd2edaea4a48f22" => :yosemite
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
