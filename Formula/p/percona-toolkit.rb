class PerconaToolkit < Formula
  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "https://github.com/percona/percona-toolkit.git", branch: "3.x"

  stable do
    url "https://downloads.percona.com/downloads/percona-toolkit/3.7.1/source/tarball/percona-toolkit-3.7.1.tar.gz"
    sha256 "d5abd944905e75800e29176aff7fdeb7062da212511e82c265be50ac03b4c19b"

    # Fix Makefile.PL to also install go tools
    patch do
      url "https://github.com/percona/percona-toolkit/commit/23be00fca557c7812ee0adfd3f9519429096d2ac.patch?full_index=1"
      sha256 "1431e42904411c5011e174f94d7c0c063f9e4d6a2744ec76b7bf92f14ef01fda"
    end
  end

  livecheck do
    url "https://www.percona.com/products-api.php", post_form: {
      version: "percona-toolkit",
    }
    regex(/value=["']?[^"' >]*?v?(\d+(?:[.-]\d+)+)[|"' >]/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05b3f3f28f2b13b7d4f7ba1b325d82a617a6d27447d6bc6262d5f00c735bae40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80bef441d4e161079ff09264e1c60b8de590aa1ffea7780fd1bd0bf393b9b4e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d4361cdd519c35383e8670636c42ca57617136638f85f1e5dc75cfce9be3b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3c89c731b466953de715f23f17798208ee16137d87fabd7d121f041ba445dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac3d2a5ec59955b3a7296e6adc223e02fc63f23328686245f885695d9da979f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989cfa41ec604acfb78a5625b686f0c0ab09b1d9b3a9f3d3db9855fa7c3c24f7"
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
