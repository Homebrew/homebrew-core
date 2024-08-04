require "language/perl"

class PerconaToolkit < Formula
  include Language::Perl::Shebang

  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.6.0/source/tarball/percona-toolkit-3.6.0.tar.gz"
  sha256 "48c2a0f7cfc987e683f60e9c7a29b0ca189e2f4b503f6d01c5baca403c09eb8d"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 1
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://docs.percona.com/percona-toolkit/version.html"
    regex(/Percona\s+Toolkit\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0b126c876ba02328832e4dfd43194851f6ce490d025d49ce045c83b03c6da9c1"
    sha256 cellar: :any,                 arm64_ventura:  "4893948c4bcbc4d964bd170b26494de826e208eb4a1e24249799bf2565631214"
    sha256 cellar: :any,                 arm64_monterey: "ba6e4ae8f0a53b44f22c0390fd09fc4e6659a171bee0a5aacb4ec9355671363e"
    sha256 cellar: :any,                 sonoma:         "ff052d8e7a4082e8bf67b0c211a9129af89e927cb9dda95f10ce99c33fc549fb"
    sha256 cellar: :any,                 ventura:        "3cbf7dcdc61ade371d94ed68de21ccd4abd8c971de851772480a290a5933e139"
    sha256 cellar: :any,                 monterey:       "d8fe4ba15521805272aea0a2b3699becff0562313104fa5fb6a175c1084e0a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd1953f231e20e8d1673ae98c1a9defab868a59a5bc29a38dc5f12fb1c90a631"
  end

  depends_on "go" => :build
  depends_on "mysql-client"

  uses_from_macos "perl"

  on_macos do
    depends_on "openssl@3"

    on_intel do
      depends_on "zstd"
    end
  end

  on_sonoma :or_newer do
    depends_on "zlib"
  end

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
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-5.008.tar.gz"
    sha256 "a2324566883b6538823c263ec8d7849b326414482a108e7650edc0bed55bcd89"
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
        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}", "NO_PERLLOCAL=1", "NO_PACKLIST=1"
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

    bin.env_script_all_files(libexec/"bin", PERL5LIB: libexec/"lib/perl5")
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp

    # Test a command that uses a native module, like DBI.
    assert_match version.to_s, shell_output("#{bin}/pt-online-schema-change --version")
  end
end
