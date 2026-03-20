class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.49.tar.gz"
  sha256 "aed2c498f7a2a78f926b95cf8ea9ce4ba13c9d8938f66cd2691cdc9f992733d0"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8534a5ff6ab47f83f3df24b3a9a82ebde88cd4cb8ac1485ae59b2926546f399d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79c528335093865fff6442462f888f5657e8ed38193385bcdbd92200478510f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe1780aeda28d52a465bd00bad52989d9d061e8001d1d94f29bc99e452cd9f2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed1ff2afcc744c168052f8b7c69c1f0e2e863712f2793da4454de2f698e439b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f83e17879746f9861c4baf49843f9be663eac2658a9d7609fb1971e58c1d0335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f87c6410a6ea540436c43829e1a3f7112bf4e15ddbaa483d026e11f8bd359259"
  end

  depends_on "perl" # macOS Perl already has the XML::Parser module
  uses_from_macos "expat"

  resource "File::ShareDir::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.14.tar.gz"
    sha256 "8f9533b198f2d4a9a5288cbc7d224f7679ad05a7a8573745599789428bc5aea0"
  end

  def install
    resource("File::ShareDir::Install").stage buildpath/"File-ShareDir-Install"
    ENV.prepend_path "PERL5LIB", buildpath/"File-ShareDir-Install/lib"

    # Homebrew vendors the new configure-time helper but does not package
    # File::ShareDir at runtime, so keep XML::Parser's legacy @INC fallback.
    inreplace "Expat/Expat.pm",
              "use File::ShareDir ();",
              ""
    inreplace "Expat/Expat.pm",
              "eval { $_share_dir = File::ShareDir::dist_dir('XML-Parser') };",
              "eval {\n    require File::ShareDir;\n    $_share_dir = File::ShareDir::dist_dir('XML-Parser');\n};"

    system "perl", "Makefile.PL", "INSTALLDIRS=vendor", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system Formula["perl"].opt_bin/"perl", "-e", "require XML::Parser;"
  end
end
