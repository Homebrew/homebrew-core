class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.11.4.tar.gz"
  sha256 "fb0d7d2558e2198d9224b44dc4220d4c62e1b5b0069312012306275be39b4ab9"
  revision 3
  head "https://github.com/innotop/innotop.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "af139f615eec93504df201d6e6fc8f927b1a7ae2866bad879183363153debd4c" => :mojave
    sha256 "6a3d4a991c111036fafbfd41fb78aa8e1f2babc1624f8e098d60df774159fbbe" => :high_sierra
    sha256 "262ec93868b11c069258438217e80ec7c892c0c8c368c4b0818495d40747782c" => :sierra
  end

  depends_on "mysql-client"
  depends_on "openssl"

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.636.tar.gz"
    sha256 "8f7ddce97c04b4b7a000e65e5d05f679c964d62c8b02c94c1a7d815bb2dd676c"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  resource "TermReadKey" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.37.tar.gz"
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
