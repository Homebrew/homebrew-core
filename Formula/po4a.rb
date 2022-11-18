require "language/perl"

class Po4a < Formula
  include Language::Perl::Shebang

  desc "Documentation translation maintenance tool"
  homepage "https://po4a.org"
  url "https://github.com/mquinson/po4a/releases/download/v0.68/po4a-0.68.tar.gz"
  sha256 "af6124e68c04a0f02a3316cd5610e5d9b923bc2ede77bb7f9b1537717f44b110"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/mquinson/po4a.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "abb3c590a097f4af80c367d9bbd1d08cf0d0a3f5ca24240a90f67eaa90d9e55e"
    sha256 cellar: :any,                 arm64_monterey: "ad1b25559dbaa2aac93c9f98ed0481253d855ace71bce2e08eda54553aee3f6d"
    sha256 cellar: :any,                 arm64_big_sur:  "9b419d577f2075c523bf97fc0c26f658355e3982f6f4a928100e333a1c2d5b80"
    sha256 cellar: :any,                 ventura:        "96df00b3e4e241a6466ebbac8c0ab45b9c6b05893c72f1061201aa095f41b886"
    sha256 cellar: :any,                 monterey:       "2a52abf9c7013fde7c322182f7f684ed9668fe420099654059dc1e7167e119d5"
    sha256 cellar: :any,                 big_sur:        "4a952520a382ea6bfd54b846efe889772e0e60fc2159b09de8d459487c057343"
    sha256 cellar: :any,                 catalina:       "508cf27a539e7c219d771ee26484ec9bd058f093e7f851592a69c9e45f5929a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f44d7c79f55d0f65486afb3c42ce690d64deb27bd99dd45a9b7ce337d554736b"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "perl"

  uses_from_macos "libxslt"

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz"
    sha256 "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717"
  end

  resource "Pod::Parser" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Parser-1.65.tar.gz"
    sha256 "3ba7bdec659416a51fe2a7e59f0883e9c6a3b21bc9d001042c1d6a32d401b28a"
  end

  resource "SGMLS" do
    url "https://cpan.metacpan.org/authors/id/R/RA/RAAB/SGMLSpm-1.1.tar.gz"
    sha256 "550c9245291c8df2242f7e88f7921a0f636c7eec92c644418e7d89cfea70b2bd"
  end

  resource "TermReadKey" do
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
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.73.tar.gz"
    sha256 "bc315fa12e8f1e3ee5e2f430d90b708a5dc7e47c867dba8dce3a6b8fbe257744"
  end

  resource "ExtUtils::CChecker" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/ExtUtils-CChecker-0.11.tar.gz"
    sha256 "117736677e37fc611f5b76374d7f952e1970eb80e1f6ad5150d516e7ae531bf5"
  end

  resource "XS::Parse::Keyword::Builder" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/XS-Parse-Keyword-0.25.tar.gz"
    sha256 "f5edb30cf7c7f220d0c6c31dc1eb554032840a99c7c298314f5cc3fef66c72c7"
  end

  resource "Syntax::Keyword::Try" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Syntax-Keyword-Try-0.27.tar.gz"
    sha256 "246e1b033e3ff22fd5420550d4b6e0d56b438cdcbb9d35cbe8b1b5ba1574de23"
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

    (testpath/"en.tex").write <<~EOS
      \\documentclass[a4paper]{article}
      \\begin{document}
      Hello from Homebrew!
      \\end{document}
    EOS

    system bin/"po4a-updatepo", "-f", "latex", "-m", "en.tex", "-p", "latex.pot"
    assert_match "Hello from Homebrew!", (testpath/"latex.pot").read

    # Markdown

    (testpath/"en.md").write("Hello from Homebrew!")
    system bin/"po4a-updatepo", "-f", "text", "-m", "en.md", "-p", "text.pot"
    assert_match "Hello from Homebrew!", (testpath/"text.pot").read
  end
end
