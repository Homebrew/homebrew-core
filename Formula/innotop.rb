class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.12.0.tar.gz"
  sha256 "f56d51b2c33a9c03f1b9d4fc5f7480f1c2104ef1e8f04def84a16f35d0bc42f6"
  license "GPL-2.0"
  revision 2
  head "https://github.com/innotop/innotop.git"

  bottle do
    cellar :any
    sha256 "937b00c65e3a404671911927fb6822401d1ee7d7d485519522cd98c4cf3c3f4b" => :catalina
    sha256 "c121ba3fb8b300e6504f82d09f37845ddec1b3e7bdcf351c4f803bb44b922bc2" => :mojave
    sha256 "34c26eaa153e3412c1d4426a3f8df76661dc260b454f06943a2e75dcee329140" => :high_sierra
  end

  depends_on "mysql-client"
  depends_on "openssl@1.1"

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
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
