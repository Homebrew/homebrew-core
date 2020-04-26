require "language/perl"

class Kpcli < Formula
  include Language::Perl::Shebang

  desc "Command-line interface to KeePass database files"
  homepage "https://kpcli.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/kpcli/kpcli-3.4.pl"
  sha256 "403e5d73cc4685722a5e4207c5fcbdad8e30475434cfba151c095e13a2658668"

  bottle do
    cellar :any
    sha256 "6a8a73548b402f3cff3920c895576f31236f9f8afc2f5f016f7642f2f50c2757" => :catalina
    sha256 "4bcd613cfa172e05c9b296e7fb2ee7dd861ee20c84c7d3db9861a3c60f07cfbf" => :mojave
    sha256 "8f0a4d3077344f69258d19b07b4cd732a86782c12106a8536b874c1585971586" => :high_sierra
  end

  depends_on "readline"

  uses_from_macos "perl"

  resource "File::KeePass" do
    url "https://cpan.metacpan.org/authors/id/R/RH/RHANDOM/File-KeePass-2.03.tar.gz"
    sha256 "c30c688027a52ff4f58cd69d6d8ef35472a7cf106d4ce94eb73a796ba7c7ffa7"
  end

  resource "Crypt::Rijndael" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Crypt-Rijndael-1.14.tar.gz"
    sha256 "6451c3dffe8703523be2bb08d1adca97e77df2a8a4dd46944d18a99330b7850e"
  end

  resource "Sort::Naturally" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Sort-Naturally-1.03.tar.gz"
    sha256 "eaab1c5c87575a7826089304ab1f8ffa7f18e6cd8b3937623e998e865ec1e746"
  end

  resource "Term::ShellUI" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRONSON/Term-ShellUI-0.92.tar.gz"
    sha256 "3279c01c76227335eeff09032a40f4b02b285151b3576c04cacd15be05942bdb"
  end

  resource "Term::Readline::Gnu" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.36.tar.gz"
    sha256 "9a08f7a4013c9b865541c10dbba1210779eb9128b961250b746d26702bab6925"
  end

  resource "Data::Password" do
    url "https://cpan.metacpan.org/authors/id/R/RA/RAZINF/Data-Password-1.12.tar.gz"
    sha256 "830cde81741ff384385412e16faba55745a54a7cc019dd23d7ed4f05d551a961"
  end

  resource "Clipboard" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Clipboard-0.22.tar.gz"
    sha256 "9fdb4dfc2e9bc2f3990b5b71649094dfe83aa12172c5a1809cf7e8b3be295ca7"
  end

  resource "Mac::Pasteboard" do
    url "https://cpan.metacpan.org/authors/id/W/WY/WYANT/Mac-Pasteboard-0.011.tar.gz"
    sha256 "bd8c4510b1e805c43e4b55155c0beaf002b649fe30b6a7841ff05e7399ba02a9"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz"
    sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resources = [
      "File::KeePass",
      "Crypt::Rijndael",
      "Sort::Naturally",
      "Term::ShellUI",
      "Data::Password",
      "Clipboard",
      "Mac::Pasteboard",
      "Capture::Tiny",
    ]
    resources.each do |r|
      resource(r).stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    resource("Term::Readline::Gnu").stage do
      # Prevent the Makefile to try and build universal binaries
      ENV.refurbish_args

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                     "--includedir=#{Formula["readline"].opt_include}",
                     "--libdir=#{Formula["readline"].opt_lib}"
      system "make", "install"
    end

    rewrite_shebang detected_perl_shebang, "kpcli-#{version}.pl"

    libexec.install "kpcli-#{version}.pl" => "kpcli"
    chmod 0755, libexec/"kpcli"
    (bin/"kpcli").write_env_script("#{libexec}/kpcli", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system bin/"kpcli", "--help"
  end
end
