require "language/perl"

class Ipv6calc < Formula
  include Language::Perl::Shebang

  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/refs/tags/4.1.0.tar.gz"
  sha256 "9c42edd9998f13465d275a3124cfdf72c93fd793d38f6d732124ac3f4b84e36e"
  license "GPL-2.0-only"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1256d562feac17f3f75aae3b399da486e984d1f48573f3ba5a1ee0ae3ea2c0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cd836a08b9cecbfd2965a2331c250100637fb1e4ecefc312c981efec5a47084"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b570877ebdb34864ecaeadf070cc3add102426491770eaafa403ec5b921ea6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b19e20c2e3586d67181f6d4de482acffdd3d5ccb6e702fc5d3e2322792c566f"
    sha256 cellar: :any_skip_relocation, ventura:        "0837cd065508e4e134642b663139273f518e477c15554350ed6845a463ace2cc"
    sha256 cellar: :any_skip_relocation, monterey:       "1b2536f666ab422df8f0e5785d66cf10564e7ef3080ece29557a6da7e171bac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94a16bd651568b6f38ed924dd32deafcc9e6f0432aeee4bcc0ef7974cf109f30"
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
