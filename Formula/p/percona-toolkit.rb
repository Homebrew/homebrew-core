class PerconaToolkit < Formula
  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.7.0/source/tarball/percona-toolkit-3.7.0.tar.gz"
  sha256 "e79f53c3227ac31c858fad061d8a000162cb5ecf8b446b90b574adde9e9ab455"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://www.percona.com/products-api.php", post_form: {
      version: "percona-toolkit",
    }
    regex(/value=["']?[^"' >]*?v?(\d+(?:[.-]\d+)+)[|"' >]/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a37d5376a12782664896830ae588d515b1bbde0d4452156c9319e6b391a453ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a37d5376a12782664896830ae588d515b1bbde0d4452156c9319e6b391a453ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5986cbc073b8a2f0cf7b6b53b1a2a7e1029e2f498d0471dd46189067884f8f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3cbec25f4fa8beb974b310c074a90e6ef1eb58bcef0c1274f59217931983a93"
    sha256 cellar: :any_skip_relocation, ventura:       "51e79707676df290463b16f92541773bd254a0b1014dac67b4c238db6cbfb6e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40e8a0ed87eaa24b89d1b6c7c47bd3298281b8fa1ea653bd80761112cbf165d1"
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
