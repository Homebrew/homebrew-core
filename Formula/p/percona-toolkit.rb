class PerconaToolkit < Formula
  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.7.0/source/tarball/percona-toolkit-3.7.0.tar.gz"
  sha256 "e79f53c3227ac31c858fad061d8a000162cb5ecf8b446b90b574adde9e9ab455"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://docs.percona.com/percona-toolkit/version.html"
    regex(/Percona\s+Toolkit\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "20acd34ed6c90230cab848cc2d60244eb417bf4eb27ce69fb48a9809681e8f57"
    sha256 cellar: :any,                 arm64_sonoma:  "9bb2cec45a90341e259b773737d409aaf0ecbb862d9578849c4740785d2d760c"
    sha256 cellar: :any,                 arm64_ventura: "cf116bff658175721671f8c152c40e669e895ff5dd9a474167fd306fcfbc97df"
    sha256 cellar: :any,                 sonoma:        "7bab53293a32c33c15b7764666d828125f4abdd244e2e8e1b486f2c078229116"
    sha256 cellar: :any,                 ventura:       "05a8dc478966a2395d7d83bc1cf816e683795db19d83417a244db43b1caca830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8ee2ab6048715176684e52a0dcbfcd186addb7bdd791c433df9c8e0f568d291"
  end

  depends_on "go" => :build
  depends_on "perl-dbd-mysql"

  uses_from_macos "perl"

  resource "JSON" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
      sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
    end
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-dbd-mysql"].opt_libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                                      "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none",
                                      "NO_PERLLOCAL=1", "NO_PACKLIST=1"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp

    # Test a command that uses a native module, like DBI.
    assert_match version.to_s, shell_output("#{bin}/pt-online-schema-change --version")
  end
end
