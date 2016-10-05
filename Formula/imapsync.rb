class Imapsync < Formula
  desc "Migrate or backup IMAP mail accounts"
  homepage "http://ks.lamiral.info/imapsync/"
  url "http://imapsync.lamiral.info/dist/imapsync-1.727.tgz"
  sha256 "72dfccb3c778dcb55460da93b00c092d38271d4a7960c221e223649ef5a143f8"
  head "https://git.fedorahosted.org/git/imapsync.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b79f63ddd1dd8d1adfc8d43a014db2f4c120b4bd9d57fc6adc630f0409d388a0" => :sierra
    sha256 "3b5ed954484a5b9c811901e04dfca07a7d8e44d69491d853bcdf4c5788f547ae" => :el_capitan
    sha256 "9a8c7bc26fedfa29398b5143039eaee6a63861c464164834ab878222d1af75ea" => :yosemite
  end

  resource "Unicode::String" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/GAAS/Unicode-String-2.10.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/GAAS/Unicode-String-2.10.tar.gz"
    sha256 "894a110ece479546af8afec0972eec7320c86c4dea4e6b354dff3c7526ba9b68"
  end

  resource "File::Copy::Recursive" do
    url "https://cpan.metacpan.org/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.38.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.38.tar.gz"
    sha256 "84ccbddf3894a88a2c2b6be68ff6ef8960037803bb36aa228b31944cfdf6deeb"
  end

  resource "Authen::NTLM" do
    url "https://cpan.metacpan.org/authors/id/N/NB/NBEBOUT/NTLM-1.09.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/N/NB/NBEBOUT/NTLM-1.09.tar.gz"
    sha256 "c823e30cda76bc15636e584302c960e2b5eeef9517c2448f7454498893151f85"
  end

  resource "Mail::IMAPClient" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.38.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.38.tar.gz"
    sha256 "d0f346d111dba93548ceac1192a993210ffcd5f81f83638ee277607bfacc1a4d"
  end

  resource "IO::Tee" do
    url "https://cpan.metacpan.org/authors/id/K/KE/KENSHAN/IO-Tee-0.64.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/K/KE/KENSHAN/IO-Tee-0.64.tar.gz"
    sha256 "3ed276b1c2d3511338653c2532e73753d284943c1a8f5159ff37fecc2b345ed6"
  end

  resource "Data::Uniqid" do
    url "https://cpan.metacpan.org/authors/id/M/MW/MWX/Data-Uniqid-0.12.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MW/MWX/Data-Uniqid-0.12.tar.gz"
    sha256 "b6919ba49b9fe98bfdf3e8accae7b9b7f78dc9e71ebbd0b7fef7a45d99324ccb"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    sha256 "4ddbb3cb985a79f69a34e7c26cde1c81120d03487e87366f9a119f90f7bdfe88"
  end

  resource "Test::MockObject" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHROMATIC/Test-MockObject-1.20150527.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CH/CHROMATIC/Test-MockObject-1.20150527.tar.gz"
    sha256 "adf1357a9014b3a397ff7ecbf1835dec376a67a37bb2e788734a627e17dc1d98"
  end

  resource "JSON::WebToken" do
    url "https://cpan.metacpan.org/authors/id/X/XA/XAICRON/JSON-WebToken-0.10.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/X/XA/XAICRON/JSON-WebToken-0.10.tar.gz"
    sha256 "77c182a98528f1714d82afc548d5b3b4dc93e67069128bb9b9413f24cf07248b"
  end

  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz"
    sha256 "7d580ff6ace0cbe555bf36b86dc8ea232581530cbeaaea09bccb57b55797f11c"
  end

  resource "Readonly" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SANKO/Readonly-2.05.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/S/SA/SANKO/Readonly-2.05.tar.gz"
    sha256 "4b23542491af010d44a5c7c861244738acc74ababae6b8838d354dfb19462b5e"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    build_pl = ["JSON::WebToken", "Module::Build::Tiny", "Readonly"]

    resources.each do |r|
      r.stage do
        next if build_pl.include? r.name
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    build_pl.each do |name|
      resource(name).stage do
        system "perl", "Build.PL", "--install_base", libexec
        system "./Build"
        system "./Build", "install"
      end
    end

    system "perl", "-c", "imapsync"
    system "pod2man", "imapsync", "imapsync.1"
    bin.install "imapsync"
    man1.install "imapsync.1"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    output = shell_output("#{bin}/imapsync --dry", 255)
    assert_match version.to_s, output
    resources.each do |r|
      next if ["Module::Build::Tiny", "Readonly"].include? r.name
      assert_match /#{r.name}\s+#{r.version}/, output
    end
  end
end
