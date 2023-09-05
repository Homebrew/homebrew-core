require "language/perl"

class PerconaToolkit < Formula
  include Language::Perl::Shebang

  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.5.4/source/tarball/percona-toolkit-3.5.4.tar.gz"
  sha256 "822003a386593352780e5d974a53de9bc5a7e35e64f7bbe631652f153c710ef8"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 1
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://docs.percona.com/percona-toolkit/version.html"
    regex(/Percona\s+Toolkit\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f73efec47769d7b701ebda892a64b21a086de1189cdeece38a2e2328c61c84a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "611538615f6a27b335e080696b51632e28bf96f62e69d64c9ddd85c3a4071735"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e4a7ba167d73b2cad33917512833d6c5ac295a9af6a1644a2aff09f324dab48"
    sha256 cellar: :any_skip_relocation, ventura:        "4b57892eddf70deb84d120196cc3500840a5abda97215ca027fce5780fa627f6"
    sha256 cellar: :any_skip_relocation, monterey:       "a3da68d2e1c2e1e3a6bdc0403a69ae53a5c89db0e2b2ae3fe61c3f89b6c95082"
    sha256 cellar: :any_skip_relocation, big_sur:        "40a0b46b42ca674bd5081e12a830ee71c5b7f6e346f0fcff5c44f61151b9783b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72c5307b2ece3580680883017356ff7b12788b26b9bcee8f82e4ea98c00065d2"
  end

  depends_on "mysql-client"
  depends_on "openssl@3"

  uses_from_macos "perl"

  # Should be installed before DBD::mysql
  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-4.050.tar.gz"
    sha256 "4f48541ff15a0a7405f76adc10f81627c33996fbf56c95c26c094444c0928d78"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
    sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    build_only_deps = %w[Devel::CheckLib]
    resources.each do |r|
      r.stage do
        install_base = if build_only_deps.include? r.name
          buildpath/"build_deps"
        else
          libexec
        end
        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix/"man"

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    # https://github.com/Homebrew/homebrew-core/issues/4936
    rewrite_shebang detected_perl_shebang, *bin.children

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp
  end
end
