require "language/perl"

class Ipv6calc < Formula
  include Language::Perl::Shebang

  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/refs/tags/4.2.0.tar.gz"
  sha256 "767dbd3d21d04e21aa9764275e2aae726f04daf66bca21fc65f0a652bdc8b50e"
  license "GPL-2.0-only"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "449741fc376d45ad6ad5eaf55a3b0486fb5613e3e255ca718e709f5feea182af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe7aa11b4cbdfc83cfe29620e330d08c2905d3d437e48ac071c1c95429f10765"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30a1095481a93e153ff99927ad4ac31a252404624e187624b7b304b17bf455c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4db2ff2d576e5c667257eafbab162300486e254a9afb81f043c5b67d1a557fc"
    sha256 cellar: :any_skip_relocation, ventura:        "79fcdae0bf897739a0284ac19a7021fa6bfb9e7bf7c455332b116b33c410bf24"
    sha256 cellar: :any_skip_relocation, monterey:       "bddbf775f72a8ba060450946f2a982a99425ecdfc17ae856f88d196e6e2873f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16ac88b7281e67599a381e82df9d7b70d4276dcb17d416c90ad0cfacfe394b7d"
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
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--datadir=#{pkgshare}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
