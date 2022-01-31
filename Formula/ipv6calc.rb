require "language/perl"

class Ipv6calc < Formula
  include Language::Perl::Shebang

  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/4.0.1.tar.gz"
  sha256 "0de7dbe66c0e3602becc18bb8f69a278a02eeaf5d58779cd1c0e0069eb80a7e6"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca999fa659227c7bdca2b63006529c0e8dad64720e607cf94e1835e27c0a78a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b545b0a609090f95d5b2d3007808ae8817cad93a78cf7ba89cb6554a0e41e2bc"
    sha256 cellar: :any_skip_relocation, monterey:       "b1925cb855c9999f95581d3694cdeb7a545ae704fa8f7d9f96231030ac712bc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fee579c01e98ca1a5123a3334f214a0d62c046440c9605c7f476b8ddc670c612"
    sha256 cellar: :any_skip_relocation, catalina:       "d83cd743ee2ad297ca525fd3de999f8025b54d404fc8261112c5a0481a69e7cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ddfd1020b80b018704b06593b591928ba6e4fe280a3d5b1757eb0cb2a32b380"
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
