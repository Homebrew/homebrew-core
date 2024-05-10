require "language/perl"

class PerconaToolkit < Formula
  include Language::Perl::Shebang

  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.5.5/source/tarball/percona-toolkit-3.5.5.tar.gz"
  sha256 "629a3c619c9f81c8451689b7840e50d13c656073a239d1ef2e5bcc250a80f884"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 2
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://docs.percona.com/percona-toolkit/version.html"
    regex(/Percona\s+Toolkit\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4f3ce735f82c07be179a6c61fb08b2eef5358b67e45d0c737f64a093ab62d2d"
    sha256 cellar: :any,                 arm64_ventura:  "3782647a866f8107481a3c48d8eb16354364588c61294e937a5e29c08d7a58c0"
    sha256 cellar: :any,                 arm64_monterey: "f0b2ceb21fadde42ea9277d66b9566a989c065b39faaed72957c2c5d8c2866e9"
    sha256 cellar: :any,                 sonoma:         "f16c675138909148c2bc3e8966a25696537c074ac1e18962cf38d40800d62e79"
    sha256 cellar: :any,                 ventura:        "7074d2704f671867df1b28cdf3435e6fbc527f1300ada8252b368465839a6876"
    sha256 cellar: :any,                 monterey:       "80d997a8f71169acf39299ee02e46244f35ac02e4193cdd7630e44e4d7e1224e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09bc4a57472177454c1f5098b92a60e560f6376ff58d22e30210b8422709aee1"
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
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-5.004.tar.gz"
    sha256 "33a6bf1b685cc50c46eb1187a3eb259ae240917bc189d26b81418790aa6da5df"
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
