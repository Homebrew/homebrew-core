require "language/perl"

class Kpcli < Formula
  include Language::Perl::Shebang

  desc "Command-line interface to KeePass database files"
  homepage "https://kpcli.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/kpcli/kpcli-4.0.pl"
  sha256 "5189d7dad69ddc9834d24757e561d2b48eaeda9cadb3e4999608ff8efe28fd35"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/kpcli[._-]v?(\d+(?:\.\d+)+)\.pl}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b71e58c56c57b0fa759ea5786bf0ba36c880783a2f5f1baf86cc590d9f0a019"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebbadc6474dbbd735f548d09e9dba2e3bc211780e56f7fdfb40a32e36a9038e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47c696e277df2f3c1396e8cb5694cc5abd596d2a506aa007b2cae9bcc004b08d"
    sha256 cellar: :any_skip_relocation, ventura:        "ae3ef7aac135d8f8cbe80a37ca5b0093e2ab8b52ebc3617dcb68c3fccce50bc9"
    sha256 cellar: :any_skip_relocation, monterey:       "34d64f8c1b9bb7242bc8493ecbae8c6e99f7222426c8f5df41aa7c3346a95b35"
    sha256 cellar: :any_skip_relocation, big_sur:        "44716bf0ce766ef67916dfbb5f15af2711fcddf2b707439a148a04e928db6563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3c8ff0cba1768546a1ade52f244bbef35447d911e6d0ae404a1cc1fb20c0d07"
  end

  depends_on "readline"

  uses_from_macos "perl"

  resource "Mac::Pasteboard" do
    on_macos do
      url "https://cpan.metacpan.org/authors/id/W/WY/WYANT/Mac-Pasteboard-0.103.tar.gz"
      sha256 "2f5e8dd2db0d6445558484ca6d42d839c5a97ee8aa1b250e694d67d5b7f6634c"
    end
  end

  resource "Clone" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.45.tar.gz"
      sha256 "cbb6ee348afa95432e4878893b46752549e70dc68fe6d9e430d1d2e99079a9e6"
    end
  end

  resource "TermReadKey" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
    sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
  end

  resource "File::KeePass" do
    url "https://cpan.metacpan.org/authors/id/R/RH/RHANDOM/File-KeePass-2.03.tar.gz"
    sha256 "c30c688027a52ff4f58cd69d6d8ef35472a7cf106d4ce94eb73a796ba7c7ffa7"
  end

  resource "Crypt::Rijndael" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Crypt-Rijndael-1.16.tar.gz"
    sha256 "6540085e3804b82a6f0752c1122cf78cadd221990136dd6fd4c097d056c84d40"
  end

  resource "Sort::Naturally" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Sort-Naturally-1.03.tar.gz"
    sha256 "eaab1c5c87575a7826089304ab1f8ffa7f18e6cd8b3937623e998e865ec1e746"
  end

  resource "Term::ShellUI" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRONSON/Term-ShellUI-0.92.tar.gz"
    sha256 "3279c01c76227335eeff09032a40f4b02b285151b3576c04cacd15be05942bdb"
  end

  resource "Term::ReadLine::Gnu" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.46.tar.gz"
    sha256 "b13832132e50366c34feac12ce82837c0a9db34ca530ae5d27db97cf9c964c7b"
  end

  resource "Data::Password" do
    url "https://cpan.metacpan.org/authors/id/R/RA/RAZINF/Data-Password-1.12.tar.gz"
    sha256 "830cde81741ff384385412e16faba55745a54a7cc019dd23d7ed4f05d551a961"
  end

  resource "Clipboard" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Clipboard-0.28.tar.gz"
    sha256 "9e8d79015194263357c25a0f5d094800fff43bdbf9f8601ec3b0ed5eb0966d26"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz"
    sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    res = resources.to_set(&:name) - ["Clipboard", "Term::Readline::Gnu"]
    res.each do |r|
      resource(r).stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    resource("Clipboard").stage do
      system "perl", "Build.PL", "--install_base", libexec
      system "./Build"
      system "./Build", "install"
    end

    resource("Term::ReadLine::Gnu").stage do
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
    (bin/"kpcli").write_env_script(libexec/"kpcli", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system bin/"kpcli", "--help"
  end
end
