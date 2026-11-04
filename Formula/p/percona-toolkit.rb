class PerconaToolkit < Formula
  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://downloads.percona.com/downloads/percona-toolkit/percona-toolkit-3.7.2/source/tarball/percona-toolkit-3.7.2.tar.gz"
  sha256 "40b53ef6887671228bbf3c9a3bed83b9ded71e56b702d339463ed29f4eb56db4"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "https://github.com/percona/percona-toolkit.git", branch: "3.x"

  livecheck do
    url "https://www.percona.com/wp-admin/admin-ajax.php", post_form: {
      action:     "percona_downloads",
      product_id: "percona-toolkit",
    }
    regex(/^(?:percona-toolkit[._-])?v?(\d+(?:\.\d+)+(?:-\d+)?)$/i)
    strategy :json do |json, regex|
      json.dig("data", "versions", 0)&.[](regex, 1)
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "807a10dfbed3cc4cd7f520843924b726000dc1a208f1f62e358795595456a318"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "819f94a7dbab83b32b4b6cd08f33197368446ee13b618545c89ef59fe301fa54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c27b2b1848dcfb449196bc87ea5720f895c5a4cd3457127fcb090617ca5ceab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ca09fe7d25e340c3e89acc236a2b5b79c1fc9df3f912d38e415dd8d52d0b8c79"
    sha256 cellar: :any_skip_relocation, sonoma:            "407f3bb0a5dceb0acd0347ba18f049123fd07ed98fb7a27c8cdcfa98322cc62a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c11d58efad22c5a362ee938b48044d45c25c3083f5c940767b77963d4139bf2f"
    sha256 cellar: :any,                 x86_64_linux:      "76654b7bc5787c22de0f31039fd9e873b72dce54457ba7ce1ee37fe97a72b3f3"
  end

  depends_on "go" => :build
  depends_on "perl-dbd-mysql"

  uses_from_macos "perl"

  resource "JSON" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.11.tar.gz"
      sha256 "713bdbe724dbb915ed50265ffe47e079a511980cb2427aa19076788bb64c3182"
    end
  end

  def install
    ENV.prepend_path "PERL5LIB", formula_opt_libexec("perl-dbd-mysql")/"lib/perl5"
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
