class PerconaToolkit < Formula
  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://downloads.percona.com/downloads/percona-toolkit/3.7.1-4/source/debian/percona-toolkit_3.7.1.orig.tar.gz"
  version "3.7.1-4"
  sha256 "c4a2502bba0118c0e4a72faa58a3174d793431e65d9aee6c260eae49216ead14"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "https://github.com/percona/percona-toolkit.git", branch: "3.x"

  livecheck do
    url "https://www.percona.com/wp-admin/admin-ajax.php", post_form: {
      action:     "percona_downloads",
      product_id: "percona-toolkit",
    }

    strategy :json do |json|
      json["data"]["versions"][0]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7275d4c15bac065f3166de29c8d6144cd81c8f7750e11a4c7a7dfaca75cf6352"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5e06870dd78edfa06d6752766d988570649f3d4ef64be4009eda917153ed767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cfec2e69b6ae5d6519be27970fbdbd2e1aab75cb0f583464329716b6f6f89c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "42d8212dfa352a40972e2cba96041b638e81fc12c4e1ddcc7942627e975efabc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aaa34073e5fd06fb6946363d183b4557399975ab3d5d5366d3241b33e8be511"
    sha256 cellar: :any,                 x86_64_linux:  "2717ba75fe1b3ceef73c444a459d9e0855ae410b827ecd7def8631aeb59553a3"
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
