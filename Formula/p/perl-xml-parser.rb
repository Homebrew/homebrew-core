class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.59.tar.gz"
  sha256 "a358fd7c49f5e27717a644a9102bd21dc7fc25a415983279c59b1580e2b62a58"
  license "Artistic-2.0"
  revision 1
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c8f72929220beadb381e32462802abfa92f68678d85918810e0ffd0e231f204"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41ff11acec89cd4a2df099c0d1d9e1672ae428cc60b893c660f6007423c7d6ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b519062690b4bfbc83d4c4ce96aa3a7522ca75f238698ab86075a61894251d70"
    sha256 cellar: :any_skip_relocation, sequoia:       "b2cb806d417b799971c8e653089080b149c8358d5efe759bc78fab897ee61ac6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8956f78a4d928735e7dc00c068e7efe32926e9d334e55fcaced6571106a371ae"
    sha256 cellar: :any,                 arm64_linux:   "dd5144a6f6daa055daa791f8d092d3a961366af925408864a629e128411944bc"
    sha256 cellar: :any,                 x86_64_linux:  "4dce3130c0a91ce63f62d4da28e31c0b43a7a657c30f6317f5cb073069318578"
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
    system formula_opt_bin("perl")/"perl", "-e", "require XML::Parser;"
  end
end
