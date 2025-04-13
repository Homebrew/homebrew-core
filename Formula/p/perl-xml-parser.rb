class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz"
  sha256 "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6652df7d2ee4241d47bd7696f6b6b063ce31cfca2d922f5be08adb4364df9952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4219900b1c2f9105cefb7e34c0d2d8ef42dee9696881a46646a58a4ed83f339d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d8331557430f37f003b838ab9dce30073e0876bddacaa1dbc07aed0ab2c3e2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "636cdbf8bf30e94da13d51d4785cf3c4bd578338cc5f84c2b219a26b788886f4"
    sha256 cellar: :any_skip_relocation, ventura:       "9876b8022ee76c8f4b100bc392c04c7fc65975b2a2b08cd24edb7057fe6d1419"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "428b10afda30e79f0fd6a06f9eadbfe784c00ab92a2add9c25f4ff8ab1eb4cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b353076b4fc4b713b7ae09fd42468ff3f77bed5ac08106c7558d4dd3347316e"
  end

  # macOS Perl already has the XML::Parser module
  depends_on "perl"
  uses_from_macos "expat"

  def install
    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
    system "make", "install"

    man.install prefix/"man"
    perl_version = Formula["perl"].version.major_minor.to_s
    site_perl = lib/"perl5/site_perl"/perl_version
    (lib/"perl5").find do |pn|
      next unless pn.file?

      subdir = pn.relative_path_from(lib/"perl5").dirname
      (site_perl/subdir).install_symlink pn
    end
  end

  test do
    system Formula["perl"].opt_bin/"perl", "-e", "require XML::Parser;"
  end
end
