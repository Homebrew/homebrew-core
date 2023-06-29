require "language/perl"

class PerconaToolkit < Formula
  include Language::Perl::Shebang

  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.5.3/source/tarball/percona-toolkit-3.5.3.tar.gz"
  sha256 "e60e4e8a737c77e836d0cf2bb817ad2336b368111833892818b6dd1f7080879b"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 1
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://docs.percona.com/percona-toolkit/version.html"
    regex(/Percona\s+Toolkit\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "11d9ed29341397933cad0e0d4fce96c3fb65f33b60a371fa7caade12f8d68d21"
    sha256 cellar: :any,                 arm64_monterey: "0c883e74898d634f5b0b755b93c54906de081bb5a013d5b236e55021b844bb3c"
    sha256 cellar: :any,                 arm64_big_sur:  "2d7ccc8dbc0621389e82ba5a41d2448e8714e131c7fdb910ff4cc89c213219b1"
    sha256 cellar: :any,                 ventura:        "a9e960d89dfd1c259daecead0fcbc0bf560538f05c87775e26b76df0cf00fd68"
    sha256 cellar: :any,                 monterey:       "7ba16e7f46b03e1927767b1d02dd574589a3b8268e384fa1b60c5ee4d8db5923"
    sha256 cellar: :any,                 big_sur:        "17529849b4ede89b2697370690edd9a394f53cb1c223097d2b1e6ec1b21cf4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90279e2c7503a214f7417604211b3417b718ee060d43c53eb01190639f99dfc0"
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
