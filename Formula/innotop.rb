class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.11.1.tar.gz"
  sha256 "c93a4fb496ce1749aaaf0a70f0899ed1fa1aa5cd231208b6b3424285c77dc1b7"
  revision 1

  head "https://github.com/innotop/innotop.git"

  bottle do
    cellar :any
    sha256 "00c4df648bcd4bc1d9a91c892c538c02c17ccecac5d725e8c1a13e440de763bc" => :sierra
    sha256 "0c410856d1a24147398aa15fd86d12a5a6b9ec1d491d994669464d2f5b7025c3" => :el_capitan
    sha256 "d773b2fea022a1e28b3ca9161f94ded8902603f99f622398ccf2d4e37cb8ffe6" => :yosemite
    sha256 "9fb20ec69dc4d7352b942779558b4a96f729a33da54169ae0233cc73533987ee" => :mavericks
  end

  depends_on :mysql
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MICHIELB/DBD-mysql-4.035.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MI/MICHIELB/DBD-mysql-4.035.tar.gz"
    sha256 "b7eca365ea16bcf4c96c2fc0221304ff9c4995e7a551886837804a8f66b61937"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
