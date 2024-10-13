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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "b8b8f01e01eeda5d59a009df6f4045076123b174d50c9db1a5ccfb6d9c744530"
    sha256 cellar: :any,                 arm64_sonoma:   "253a0ada81a5be15993314ed1d761cfdc7c88340c23a78ef2c2491a158d7bc8b"
    sha256 cellar: :any,                 arm64_ventura:  "14f7a30244e3aadd3e155d2e3d9d61449c268fd13f90002cb67fb933ab6c795d"
    sha256 cellar: :any,                 arm64_monterey: "dcf0182a7812e2be56d86eba45f3591bdb870205537812a7ae8ef66f11593a7a"
    sha256 cellar: :any,                 sonoma:         "9c80e8122754a1f5f3e81470cb65bc2bb17e9cd7cd7b6f9fd533234d8ee2471c"
    sha256 cellar: :any,                 ventura:        "337b5b24fed8ed055b48bbff8669c25ba6cb24cfa5ffd88b03b4e91d6540a326"
    sha256 cellar: :any,                 monterey:       "3b5cb112c48f8d53f4d7c35b85072a248dbe9d8bea5d4d047aeb3052248f5253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d300c45095b1a1f61220eed15243b8fa3aa8bb62e93837fd7be546f0dc9d6c12"
  end

  depends_on "go" => :build
  depends_on "mysql-client"

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

        make_args = []
        make_args << "OTHERLDFLAGS=-Wl,-dead_strip_dylibs" if r.name == "DBD::mysql" && OS.mac?

        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}", "NO_PERLLOCAL=1", "NO_PACKLIST=1"
        system "make", "install", *make_args
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
