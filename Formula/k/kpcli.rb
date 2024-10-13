require "language/perl"

class Kpcli < Formula
  include Language::Perl::Shebang

  desc "Command-line interface to KeePass database files"
  homepage "https://kpcli.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/kpcli/kpcli-4.1.2.pl"
  sha256 "86fc820bc7945cd9b577583efe4127565951268902860256ceea100795ddf23f"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/kpcli[._-]v?(\d+(?:\.\d+)+)\.pl}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b1b125eaccde0591df6ba5466c7b8cac603fa10a9feb52259675a477cb3499b"
    sha256 cellar: :any,                 arm64_sonoma:  "2f87120e6d10687726c614522ffc22cf6a901e65734f40044756ae508c8802c1"
    sha256 cellar: :any,                 arm64_ventura: "bf1547ebf1f3b46d6e872c17f79580f3025ee33b70903a56b47f53747b45a80d"
    sha256 cellar: :any,                 sonoma:        "da87e293162f2e51b66c6247d7d9d763fbe92cf6f42f6e5b5edccf68055f344b"
    sha256 cellar: :any,                 ventura:       "226beef4ff77b9c7dfad42a2c844eef911f95a90d8ea7007e53c9bca63c08ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ede73ef4880f2c1f13dcd9e94b2936d305b1f9dd48b327cae3e13123c98d5bfa"
  end

  depends_on "readline"

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  resource "Mac::Pasteboard" do
    on_macos do
      url "https://cpan.metacpan.org/authors/id/W/WY/WYANT/Mac-Pasteboard-0.105.tar.gz"
      sha256 "2d5592abb1f015273eaa6d832edd922f8695368bc69fea8f413b826bb1e68633"
    end
  end

  resource "Clone" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.47.tar.gz"
      sha256 "4c2c0cb9a483efbf970cb1a75b2ca75b0e18cb84bcb5c09624f86e26b09c211d"
    end
  end

  resource "Term::ReadKey" do
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
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Clipboard-0.30.tar.gz"
    sha256 "d7b3dd7b9ebaac546ec9d4862b1fa413b0279833917901d0b672fd1804384195"
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
