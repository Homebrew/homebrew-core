require "language/perl"

class Ipv6calc < Formula
  include Language::Perl::Shebang

  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/4.0.0.tar.gz"
  sha256 "4d23c471b472271b48421b5d18309492f615c85c75f2abc17c5c5a4d8e3a4635"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2f22205da91a6c13ef94c24d506c2fd5f0a53d2f206d721e240c1942764db1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8532274ecc261d17d7390821b9e8b432f56cdafe97ba34c583437b1fadfa7f27"
    sha256 cellar: :any_skip_relocation, monterey:       "74f417c9a6cd2ce32185c55dfc7a12a9a8a0e26439dc6c76608b44764713cbdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee4ad9470fc4e89698937c724f1124d393289f6c3022a397cb3525562843fc53"
    sha256 cellar: :any_skip_relocation, catalina:       "032973accb1642b43fcf7320e8dd76e621c8024f3b6b0caf2fb24e69d90429d7"
    sha256 cellar: :any_skip_relocation, mojave:         "4a83aadc45974b755d94b59f2fd4e8fb4637139d527e4474122983a229731cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "748772297ce211e30da123ccab4c9204738703e62cfe1ab90238dac434d9fb70"
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
