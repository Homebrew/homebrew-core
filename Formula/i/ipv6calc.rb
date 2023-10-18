require "language/perl"

class Ipv6calc < Formula
  include Language::Perl::Shebang

  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/4.0.2.tar.gz"
  sha256 "f96a89bdce201ec313f66514ee52eeab5f5ead3d2ba9efe5ed9f757632cd01a1"
  license "GPL-2.0-only"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "998b3032b53b1574724e99012321afe14594d495c20429f9ab2702596f7a6d60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5874495f7ad81f2ae6081cc2663388757f5486e587d75de777c978f2cb540cc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf5d7938f932349c6f66c94e7c57cabb397c329af9a1b68fec2b89a5f35ebf16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "241adc72c83e48e1edfe48a783956afbb5c8ce4523057a9387924574ff48bc7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7469410b184bb7d68cad734da17ff8bc309788dc95fd2532b293f06353ca920"
    sha256 cellar: :any_skip_relocation, ventura:        "00d7052f3993aade4982429703d8b325be27e48984227b45efd405768a246208"
    sha256 cellar: :any_skip_relocation, monterey:       "8e048db48b8c10534cc260cc20c50c38bdf4df578df24cf257665d2d8d47a9ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9401ab4a66023889a7c740202b629c93fb01d27bcace0b3c195f5e48c76b65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "761dd17c3d27772531e46280351162df8ba5be64a3c240940c00797c55553bce"
  end

  uses_from_macos "perl"

  on_linux do
    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.21.tar.gz"
      sha256 "96265860cd61bde16e8415dcfbf108056de162caa0ac37f81eb695c9d2e0ab77"
    end

    resource "HTML::Entities" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.81.tar.gz"
      sha256 "c0910a5c8f92f8817edd06ccfd224ba1c2ebe8c10f551f032587a1fc83d62ff2"
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
