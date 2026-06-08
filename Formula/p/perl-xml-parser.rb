class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.59.tar.gz"
  sha256 "a358fd7c49f5e27717a644a9102bd21dc7fc25a415983279c59b1580e2b62a58"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c57352fbabcea8144c0016fe0e5efe605f62973b471e3a353ab80859d75bf235"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b00c4634cb1610f5f72b5c19724fd909999d7fdd01fcd7d430d831bb9b70d86c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8cb9abec7c27e96e3adfb7328fefa2c718682b497f065a6b98b41a81f17b666"
    sha256 cellar: :any_skip_relocation, sonoma:        "953c075a6311b82f184e2bb1fa93f8a1eea4641382c41b34c2c7b75cc36938d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f259ec7e84a5e4df245a9550ba594dfbe9c2bb68f235efc45529f3313c7e5d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f621416e0df9289a64074f9885d1c89da47d299a21d3d6077de89f452cf02a7"
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
