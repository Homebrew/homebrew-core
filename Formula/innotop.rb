class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.11.4.tar.gz"
  sha256 "fb0d7d2558e2198d9224b44dc4220d4c62e1b5b0069312012306275be39b4ab9"
  revision 1
  head "https://github.com/innotop/innotop.git"

  bottle do
    cellar :any
    sha256 "488527ac883bf16f07604f4233be95d6c62d161aefcc89da403130b9dd497e09" => :high_sierra
    sha256 "ecbbf1bb0f2e3036d51e0dfd7490da6bbffb36b738e96962356b039ae38589fe" => :sierra
    sha256 "a7c32b41e55a7e84cda7a415e704268a893fa6f6928ed3bac156fbdd50d02dd6" => :el_capitan
  end

  depends_on "mysql"
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
