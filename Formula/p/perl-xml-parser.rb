class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.57.tar.gz"
  sha256 "a846bf77032e953e8344989780fa6a885e2a5226ebcaa93dae1d3df9b184e9cf"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da63568c14d05224f6c76433e4505121d0781bf539da795e0c32405011c69003"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcd52664202afda0759f918e9942d6c8584ba5f7c56550efb4f5615a524f227a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dad40769fbe7595b6abe590ec54e6049677642eeb49796cff48233f8be2835a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b997dab79d7f8761410c7e6ee0115153d0a0f0105ebf0b0f3837b704fa6ed1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87b2c069bb1d724e69ff177c20c69e54a39244dc7add672246d87e36948c1a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6466a583664968edb1703499fdca80ea6682c0b115af5dab513f948994aaeb40"
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
