class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.14.tar.gz"
  sha256 "319cfb48d14fbdcd64dbea5f085755474c2936f1ab9543c66f114735930a77a7"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
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
