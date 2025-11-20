class PerconaToolkit < Formula
  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://downloads.percona.com/downloads/percona-toolkit/3.7.0-2/source/tarball/percona-toolkit-3.7.0.tar.gz"
  sha256 "192c899dcfa26eca1b9e8692b7b687d143154902b6089afb03c14ea1b93e432d"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "https://github.com/percona/percona-toolkit.git", branch: "3.x"

  livecheck do
    url "https://www.percona.com/products-api.php", post_form: {
      version: "percona-toolkit",
    }
    regex(/value=["']?[^"' >]*?v?(\d+(?:[.-]\d+)+)[|"' >]/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "098ce6dae0da3d02a7ca65217ca96cd604afcd089ac11fa64dc25135d7ef01e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35bbdc1161bee62d4bf0304704413393c330468eb8ce88c9bd70692b1f588c75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35bbdc1161bee62d4bf0304704413393c330468eb8ce88c9bd70692b1f588c75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15a499710d1aacc752986af8f2cc842a7652564a4938a5bc6b48e602cd8e4d59"
    sha256 cellar: :any_skip_relocation, sonoma:        "32586dd3bdacb64ecb568d550750a7f140542f4715c5dfb5c84898f719420040"
    sha256 cellar: :any_skip_relocation, ventura:       "5ee9f37aca9455631f1d4301bf141574ad8bf99601a6b5b52198fcfe31f5cb7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6afb3a5188e3d60f607bdfe3ce49161b600d856ed0f3f6f4406f3776bf4da1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b43428c0da2027f1a735030216ad956da2ea4395fc7d5039b6cb90b3b443463a"
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
