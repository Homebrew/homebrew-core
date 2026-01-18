class PerconaToolkit < Formula
  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://downloads.percona.com/downloads/percona-toolkit/3.7.1/source/tarball/percona-toolkit-3.7.1.tar.gz"
  sha256 "d5abd944905e75800e29176aff7fdeb7062da212511e82c265be50ac03b4c19b"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "https://github.com/percona/percona-toolkit.git", branch: "3.x"

  livecheck do
    url "https://www.percona.com/products-api.php", post_form: {
      version: "percona-toolkit",
    }
    regex(/value=["']?[^"' >]*?v?(\d+(?:[.-]\d+)+)[|"' >]/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1127bedad067c639c8fd94ec410db7124a4b0c2b1d8c97fb572c59df0d44e672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1127bedad067c639c8fd94ec410db7124a4b0c2b1d8c97fb572c59df0d44e672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1127bedad067c639c8fd94ec410db7124a4b0c2b1d8c97fb572c59df0d44e672"
    sha256 cellar: :any_skip_relocation, sonoma:        "1127bedad067c639c8fd94ec410db7124a4b0c2b1d8c97fb572c59df0d44e672"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175073257e991966b0f6ce20973b197c033f7000a3feec84b2980e7ac0ddb167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "175073257e991966b0f6ce20973b197c033f7000a3feec84b2980e7ac0ddb167"
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
