class Kpcli < Formula
  desc "Command-line interface to KeePass database files"
  homepage "https://kpcli.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/kpcli/kpcli-4.1.3.pl"
  sha256 "c91363e4e07f3521a867f68db602c95b53dc167e4366ee7ff254252b4176c62f"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/kpcli[._-]v?(\d+(?:\.\d+)+)\.pl}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e0ae609c2cc96fea3b5b840b1c2129403405cfcaa5b3e8c9441a0df7e1f9aa9e"
    sha256 cellar: :any, arm64_sequoia: "328a45daca1f2b366cc9e39c030e570a50b909e17c5eb3f40f23a3cf53dc9d33"
    sha256 cellar: :any, arm64_sonoma:  "9ea88ccdc07297312b83d197992faa1804720ba6efd472b9a220ab6afb850db3"
    sha256 cellar: :any, tahoe:         "cc33849f2206d6680bd40bc6c61547e4b4d886bea263c64cdd52257c2417c46f"
    sha256 cellar: :any, sequoia:       "80e6cc121a3cfc33d4105323af5994dc4f3a2ff71af50e19db15af27d1ea1fa8"
    sha256 cellar: :any, sonoma:        "3cd8bd72986cfb8920bbcc097fd126f547e5577c45736f84d3572a75eada9776"
    sha256 cellar: :any, arm64_linux:   "829278e4ef6d3057e1f77bae898626b662ccb8d7a6752a979f14e087b7161028"
    sha256 cellar: :any, x86_64_linux:  "cef290dfb2cd7da018353cd78e129e1972e5411ca73c4e0ae92a0d7035271071"
  end

  depends_on "expat"
  depends_on "readline"

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  resource "Mac::Pasteboard" do
    on_macos do
      url "https://cpan.metacpan.org/authors/id/W/WY/WYANT/Mac-Pasteboard-0.105.tar.gz"
      sha256 "2d5592abb1f015273eaa6d832edd922f8695368bc69fea8f413b826bb1e68633"
    end
  end

  resource "Clone" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.47.tar.gz"
      sha256 "4c2c0cb9a483efbf970cb1a75b2ca75b0e18cb84bcb5c09624f86e26b09c211d"
    end
  end

  resource "Term::ReadKey" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
    sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
  end

  resource "Class::Inspector" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Class-Inspector-1.36.tar.gz"
    sha256 "cc295d23a472687c24489d58226ead23b9fdc2588e522f0b5f0747741700694e"
  end

  resource "File::ShareDir" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-ShareDir-1.118.tar.gz"
    sha256 "3bb2a20ba35df958dc0a4f2306fc05d903d8b8c4de3c8beefce17739d281c958"
  end

  resource "File::ShareDir::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.14.tar.gz"
    sha256 "8f9533b198f2d4a9a5288cbc7d224f7679ad05a7a8573745599789428bc5aea0"
  end

  resource "XML::Parser" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.59.tar.gz"
    sha256 "a358fd7c49f5e27717a644a9102bd21dc7fc25a415983279c59b1580e2b62a58"
  end

  resource "File::KeePass" do
    url "https://cpan.metacpan.org/authors/id/R/RH/RHANDOM/File-KeePass-2.03.tar.gz"
    sha256 "c30c688027a52ff4f58cd69d6d8ef35472a7cf106d4ce94eb73a796ba7c7ffa7"
  end

  resource "Crypt::Rijndael" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Crypt-Rijndael-1.16.tar.gz"
    sha256 "6540085e3804b82a6f0752c1122cf78cadd221990136dd6fd4c097d056c84d40"
  end

  resource "Sort::Naturally" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Sort-Naturally-1.03.tar.gz"
    sha256 "eaab1c5c87575a7826089304ab1f8ffa7f18e6cd8b3937623e998e865ec1e746"
  end

  resource "Term::ShellUI" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRONSON/Term-ShellUI-0.92.tar.gz"
    sha256 "3279c01c76227335eeff09032a40f4b02b285151b3576c04cacd15be05942bdb"
  end

  resource "Term::ReadLine::Gnu" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.47.tar.gz"
    sha256 "3b07ac8a9b494c50aa87a40dccab3f879b92eb9527ac0f2ded5d4743d166b649"
  end

  resource "Data::Password" do
    url "https://cpan.metacpan.org/authors/id/R/RA/RAZINF/Data-Password-1.12.tar.gz"
    sha256 "830cde81741ff384385412e16faba55745a54a7cc019dd23d7ed4f05d551a961"
  end

  resource "Clipboard" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Clipboard-0.31.tar.gz"
    sha256 "af6dc25cf8299d3ed612a2182d0c98e7a011f12ac5f6634c1e9180d3204c2cd8"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.50.tar.gz"
    sha256 "ca6e8d7ce7471c2be54e1009f64c367d7ee233a2894cacf52ebe6f53b04e81e5"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    res = resources.to_set(&:name) - ["Clipboard", "Term::Readline::Gnu"]
    res.each do |r|
      resource(r).stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    resource("Clipboard").stage do
      system "perl", "Build.PL", "--install_base", libexec
      system "./Build"
      system "./Build", "install"
    end

    resource("Term::ReadLine::Gnu").stage do
      # Prevent the Makefile to try and build universal binaries
      ENV.refurbish_args

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                     "--includedir=#{formula_opt_include("readline")}",
                     "--libdir=#{formula_opt_lib("readline")}"
      system "make", "install"
    end

    libexec.install "kpcli-#{version}.pl" => "kpcli"
    chmod 0755, libexec/"kpcli"
    (bin/"kpcli").write_env_script(libexec/"kpcli", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system bin/"kpcli", "--help"

    database_file = testpath/"test.kdbx"
    database_secret = "testsecret"
    password_file = testpath/"test.pw"
    password_file.write "#{database_secret}\n"

    (testpath/"create_database.pl").write <<~PERL
      use File::KeePass;

      my $keepass = File::KeePass->new;
      my $group = $keepass->add_group({ title => "HomebrewGroup" });
      $keepass->add_entry({
        title    => "kpcli test entry",
        username => "kpcli",
        password => "KPCLI",
        group    => $group,
      });
      $keepass->save_db($ARGV[0], "#{database_secret}");
    PERL

    ENV.prepend_path "PERL5LIB", libexec/"lib/perl5"
    system "perl", testpath/"create_database.pl", database_file

    output = shell_output(
      "#{bin}/kpcli --kdb=#{database_file} --pwfile=#{password_file} " \
      "--readonly --command='ls HomebrewGroup'",
    )
    assert_match "kpcli test entry", output
  end
end
