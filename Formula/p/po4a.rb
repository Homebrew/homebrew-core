require "language/perl"

class Po4a < Formula
  include Language::Perl::Shebang

  desc "Documentation translation maintenance tool"
  homepage "https://po4a.org"
  url "https://github.com/mquinson/po4a/archive/refs/tags/v0.74.tar.gz"
  sha256 "6e390eb7707501a86f2e648d78fddb0d211d1e8699aa1ee201176e9f966a798b"
  license "GPL-2.0-or-later"
  head "https://github.com/mquinson/po4a.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7624436108971c111880fd35bc7766707a6bd3e0065371004417b1b2cd3de75f"
    sha256 cellar: :any,                 arm64_sequoia: "bdccf6b6345463afc6e11516c74d5c585ac9fe6f98011cfcd4e8c2ce930eb44e"
    sha256 cellar: :any,                 arm64_sonoma:  "3c49b77a9b3e77a508fc1d6bad432d289ed433d7926209f3325488a21b4aa054"
    sha256 cellar: :any,                 arm64_ventura: "067ad1ef4e3830635e59a12e6884632f11a9140c9af5538381ede46815c33ae5"
    sha256 cellar: :any,                 sonoma:        "650b1513dcb4670a7a55a8b686cd2d8e09d23eb7f0ae1ed71d1f34c56272cfc9"
    sha256 cellar: :any,                 ventura:       "22a57781a1083f9e41507a45b80de0b63ce207e8a6ce52a0c166084d87922c93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "873a75f430ad21edd023fbb9dc858fc75df48092bc77e19ece740ce766006f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56d33a2d3cfe1d88e5af7367056285675c41681ccb10cc9bf696200b9ade107a"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "perl"

  uses_from_macos "libxslt"

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/Locale-gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
    sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
  end

  resource "Pod::Parser" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Parser-1.67.tar.gz"
    sha256 "5deccbf55d750ce65588cd211c1a03fa1ef3aaa15d1ac2b8d85383a42c1427ea"
  end

  resource "SGMLS" do
    url "https://cpan.metacpan.org/authors/id/R/RA/RAAB/SGMLSpm-1.1.tar.gz"
    sha256 "550c9245291c8df2242f7e88f7921a0f636c7eec92c644418e7d89cfea70b2bd"
  end

  resource "Term::ReadKey" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
    sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
  end

  resource "Text::WrapI18N" do
    url "https://cpan.metacpan.org/authors/id/K/KU/KUBOTA/Text-WrapI18N-0.06.tar.gz"
    sha256 "4bd29a17f0c2c792d12c1005b3c276f2ab0fae39c00859ae1741d7941846a488"
  end

  resource "Unicode::GCString" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end

  resource "YAML::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.76.tar.gz"
    sha256 "a8d584394cf069bf8f17cba3dd5099003b097fce316c31fb094f1b1c171c08a3"
  end

  resource "ExtUtils::CChecker" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/ExtUtils-CChecker-0.12.tar.gz"
    sha256 "8b87d145337dec1ee754d30871d0b105c180ad4c92c7dc0c7fadd76cec8c57d3"
  end

  resource "Class::Inspector" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Class-Inspector-1.32.tar.gz"
    sha256 "cefadc8b5338e43e570bc43f583e7c98d535c17b196bcf9084bb41d561cc0535"
  end

  resource "File::ShareDir" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-ShareDir-1.118.tar.gz"
    sha256 "3bb2a20ba35df958dc0a4f2306fc05d903d8b8c4de3c8beefce17739d281c958"
  end

  resource "XS::Parse::Keyword::Builder" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/XS-Parse-Keyword-0.48.tar.gz"
    sha256 "857a070ba465ab5b89d4d8d36d92358edd66e5e7b4a91584611d85125ac9a9c7"
  end

  resource "Syntax::Keyword::Try" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Syntax-Keyword-Try-0.30.tar.gz"
    sha256 "f068f0b9c71fff8fef6d8a9e9ed6951cb7a52b976322bd955181cc5e7b17e692"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resources.each do |r|
      r.stage do
        if File.exist?("Makefile.PL")
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "NO_MYMETA=1"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system "./Build"
          system "./Build", "install"
        end
      end
    end

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "perl", "Build.PL", "--install_base", libexec
    system "./Build"
    system "./Build", "install"

    shell_scripts = %w[po4a-display-man po4a-display-pod]

    %w[msguntypot po4a po4a-display-man po4a-display-pod
       po4a-gettextize po4a-translate po4a-normalize po4a-updatepo].each do |cmd|
      rewrite_shebang detected_perl_shebang, libexec/"bin"/cmd unless shell_scripts.include? cmd

      (bin/cmd).write_env_script(libexec/"bin"/cmd, PERL5LIB: ENV["PERL5LIB"])
    end

    man1.install Dir[libexec/"man/man1/{msguntypot.1p.gz,po4a*}"]
    man3.install Dir[libexec/"man/man3/Locale::Po4a::*"]
    man7.install Dir[libexec/"man/man7/*"]
  end

  test do
    # LaTeX

    (testpath/"en.tex").write <<~'TEX'
      \documentclass[a4paper]{article}
      \begin{document}
      Hello from Homebrew!
      \end{document}
    TEX

    system bin/"po4a-updatepo", "-f", "latex", "-m", "en.tex", "-p", "latex.pot"
    assert_match "Hello from Homebrew!", (testpath/"latex.pot").read

    # Markdown

    (testpath/"en.md").write("Hello from Homebrew!")
    system bin/"po4a-updatepo", "-f", "text", "-m", "en.md", "-p", "text.pot"
    assert_match "Hello from Homebrew!", (testpath/"text.pot").read
  end
end
