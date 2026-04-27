class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.58.tar.gz"
  sha256 "8e0bd510a6095374aff14e4f0cea62c40df5c434ac703850f20ae8edb2c9b100"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "988a556ff6c3dd2c6e71d03da900bcb2f0ed04bc7576ac79f8c125dafced0d7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13d61ff8754979f58c7dbe93c833d67cbe088686a67fc0c60091e9025d29ba1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "863f641f47a0aefd81728c492285558c780de92f6445ba2febe32e1c6fa6a3fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d3b4be770b19f2db6c0ca9db1e8f03f7918144a51a192f264bf8bb346ab88a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d25f15fbcdad7090191b2090a8275a8a50904cc430e4277c6630dc935457e32f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "871194e390bca17e814d65816d2a19951f3521f6016dd4acde7248bff85fba4b"
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
