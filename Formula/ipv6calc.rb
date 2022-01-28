require "language/perl"

class Ipv6calc < Formula
  include Language::Perl::Shebang

  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/4.0.1.tar.gz"
  sha256 "0de7dbe66c0e3602becc18bb8f69a278a02eeaf5d58779cd1c0e0069eb80a7e6"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58696af7ba0a63396bed553371b9587045a86bac2109a545357277f7d5e66d22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a3d049f6193d2f1484b00f9144bb1a7608dd5d849389b9a88bf641e10354b52"
    sha256 cellar: :any_skip_relocation, monterey:       "fd10d04f8d812e666cc4b56c9b047f3e2c7ea0fc34bf08eed66200ca15d7bbc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fff318a4b08e74297da3c2707dff2c418a5d8394ce383665826a240be1c147e5"
    sha256 cellar: :any_skip_relocation, catalina:       "066f85ae793982f7a079772d351de2e2654087798541fc67462f2d9c603ed7e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d022ade3c97e5565b523eabdad8e36342af353e742bdbb6c84e1e6b9943a689"
  end

  uses_from_macos "perl"

  on_linux do
    resource "URI::Escape" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/URI-1.72.tar.gz"
      sha256 "35f14431d4b300de4be1163b0b5332de2d7fbda4f05ff1ed198a8e9330d40a32"
    end

    resource "HTML::Entities" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.76.tar.gz"
      sha256 "64d9e2eb2b420f1492da01ec0e6976363245b4be9290f03f10b7d2cb63fa2f61"
    end

    resource "DIGEST::Sha1" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Digest-SHA1-2.13.tar.gz"
      sha256 "68c1dac2187421f0eb7abf71452a06f190181b8fc4b28ededf5b90296fb943cc"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV.prepend_path "PERL5LIB", libexec/"lib"

      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "install"
        end
      end

      rewrite_shebang detected_perl_shebang, "ipv6calcweb/ipv6calcweb.cgi.in"

      # ipv6calcweb.cgi is a CGI script so it does not use PERL5LIB
      # Add the lib path at the top of the file
      inreplace "ipv6calcweb/ipv6calcweb.cgi.in",
                "use URI::Escape;",
                "use lib \"#{libexec}/lib/perl5/\";\nuse URI::Escape;"
    end

    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
