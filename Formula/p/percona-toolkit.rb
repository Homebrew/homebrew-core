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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5e94948afecd0aa02aae51c7af748c03f0f4177e45a3883b6570fdd903ba6c93"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b658d499a410dab71ae145033feecddfc60008e7da8d41b009641e7829fa523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63dd4ce19ea4d1ac034aa8c977941923ed324a8b806dd0862dd7c3a435615a5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fa7ba93a056a89ba9d7c2e2c4886ba43f277ab152eb93621ded05c0690ae3f9b"
    sha256 cellar: :any,                 x86_64_linux:      "c1baa353ffe1c5d60befd6c190d58a0c980af6debaa4c6474cedc90810be444e"
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
