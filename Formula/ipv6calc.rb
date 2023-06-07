require "language/perl"

class Ipv6calc < Formula
  include Language::Perl::Shebang

  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/4.0.2.tar.gz"
  sha256 "f96a89bdce201ec313f66514ee52eeab5f5ead3d2ba9efe5ed9f757632cd01a1"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec95bedb2ffc3314f59eabfb03c15e3d2df693cbf6d12751ea6ceb9f303e8a20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fcdc8e16f2afbca82bed3e603ebb43909bcc606e18a8d272ead9265c5a29e3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3f06f0c71e1b4276f9aa6fbfca5dd6faf075b4e3ca6021a65a63842d1ece4a0"
    sha256 cellar: :any_skip_relocation, ventura:        "d2329add8cc4d59f0dfe8e31fe146410e0de8fd70b67f8efdf351f4311950412"
    sha256 cellar: :any_skip_relocation, monterey:       "1c59cf12317c2376dc3822a35683778664f6f1a0224329ddca4135390bb1874b"
    sha256 cellar: :any_skip_relocation, big_sur:        "98418aac5aed19fef65e68151cf86e5dbd8189c00abade45ab7ffcc47077ad46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "844ebdae509e6b79ce9cb74474db0f5563f4e277220f887a38b5c5d1a814a02f"
  end

  uses_from_macos "perl"

  on_linux do
    resource "URI::Escape" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.17.tar.gz"
      sha256 "5f7e42b769cb27499113cfae4b786c37d49e7c7d32dbb469602cd808308568f8"
    end

    resource "HTML::Entities" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.80.tar.gz"
      sha256 "63411db03016747e37c2636db11b05f8cc71608ef5bff36d04ddb0dc92f7835b"
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
