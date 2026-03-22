class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.51.tar.gz"
  sha256 "61b07878ff5095375fbbf095c1779808d6d99cf142a176bbf8900f42604e82eb"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00210c0bc24ba6c07007235d5e4b1e8917378a3649d6b2298c0ecbecedb5df2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b38ccf43b930b6e43511a5fc570766e7c2d55e27d9b4eae293faf27755eca86e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d3589a8b05da0c0e3ad6a55f5bc007f69da2f9cd564d879de7c3618d26cbcdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf109271521aecc0149e3ca6c461c09f768043b6af710adbd1e7d00e50529a12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25b444e4c606ad25612adeaa7ae49203c37b679c28eec5c73854e4a9496241f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c79cadbda707fdc0c9769fad2321033e2fa39c26c75cd3f9c0e199883d846827"
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
