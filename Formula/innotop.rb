class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.11.1.tar.gz"
  sha256 "c93a4fb496ce1749aaaf0a70f0899ed1fa1aa5cd231208b6b3424285c77dc1b7"
  revision 2

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
    url "https://cpan.metacpan.org/authors/id/M/MI/MICHIELB/DBD-mysql-4.041.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MI/MICHIELB/DBD-mysql-4.041.tar.gz"
    sha256 "4777de11c464b515db9da95c08c225900d0594b65ba3256982dc21f9f9379040"
  end

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.636.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/T/TI/TIMB/DBI-1.636.tar.gz"
    sha256 "8f7ddce97c04b4b7a000e65e5d05f679c964d62c8b02c94c1a7d815bb2dd676c"
  end

  resource "TermReadKey" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.37.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/J/JS/JSTOWE/TermReadKey-2.37.tar.gz"
    sha256 "4a9383cf2e0e0194668fe2bd546e894ffad41d556b41d2f2f577c8db682db241"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    inreplace "innotop", "#!/usr/bin/env perl", "#!/usr/bin/perl"

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
