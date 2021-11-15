require "language/perl"

class Kpcli < Formula
  include Language::Perl::Shebang

  desc "Command-line interface to KeePass database files"
  homepage "https://kpcli.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/kpcli/kpcli-3.6.pl"
  sha256 "01f23882d458dfffc176fe5f268ced13c667de22b7fbf60d488eca87f3362deb"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/kpcli[._-]v?(\d+(?:\.\d+)+)\.pl}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aea59c0eddc9fa427b8626612f82ea57cafd8c9b5a9ab3a0d0545b60f9097f09"
    sha256 cellar: :any,                 arm64_big_sur:  "793a7e8ce3bf2a0beae2b0a51b14e3915df7f8ba05f20b4bf26c5ed3dba11e98"
    sha256 cellar: :any,                 monterey:       "c79ae0ade5822f60da1daf6bee7efb2b97e42cb6dedab8c99d2a9fc12781cb1f"
    sha256 cellar: :any,                 big_sur:        "8431834a984e31a2bb567913b8bd82ec97e616879f058c10e1b0af77fc9528e8"
    sha256 cellar: :any,                 catalina:       "ef0dcac2509419af4f99407cd40d7072a44d53472cb692afa49bae06bb91fb71"
    sha256 cellar: :any,                 mojave:         "7635208158e7c7a7dd1e7a4e28d51d2c836d6e2bd9f6c329c265cebdf4b69939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a340307dd0234be2d5db82bfb5a949a5547fd2a83b239766c535aef2237e195"
  end

  depends_on "readline"

  uses_from_macos "perl"

  on_macos do
    resource "Mac::Pasteboard" do
      url "https://cpan.metacpan.org/authors/id/W/WY/WYANT/Mac-Pasteboard-0.011.tar.gz"
      sha256 "bd8c4510b1e805c43e4b55155c0beaf002b649fe30b6a7841ff05e7399ba02a9"
    end
  end

  on_linux do
    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.45.tar.gz"
      sha256 "cbb6ee348afa95432e4878893b46752549e70dc68fe6d9e430d1d2e99079a9e6"
    end

    resource "TermReadKey" do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz"
    sha256 "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717"
  end

  resource "File::KeePass" do
    url "https://cpan.metacpan.org/authors/id/R/RH/RHANDOM/File-KeePass-2.03.tar.gz"
    sha256 "c30c688027a52ff4f58cd69d6d8ef35472a7cf106d4ce94eb73a796ba7c7ffa7"
  end

  resource "Crypt::Rijndael" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Crypt-Rijndael-1.15.tar.gz"
    sha256 "a0989b55990d7905d1b5bf524cd8b46aadc0de778414d4ca8d406aa2aa594163"
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
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.37.tar.gz"
    sha256 "3bd31a998a9c14748ee553aed3e6b888ec47ff57c07fc5beafb04a38a72f0078"
  end

  resource "Data::Password" do
    url "https://cpan.metacpan.org/authors/id/R/RA/RAZINF/Data-Password-1.12.tar.gz"
    sha256 "830cde81741ff384385412e16faba55745a54a7cc019dd23d7ed4f05d551a961"
  end

  resource "Clipboard" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Clipboard-0.26.tar.gz"
    sha256 "886ae43dc8538f9bfc4e07fdbcf09b7fbd6ee59c31f364618c859de14953c58a"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz"
    sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    res = resources.map(&:name).to_set - ["Clipboard", "Term::Readline::Gnu"]
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

    resource("Term::Readline::Gnu").stage do
      # Prevent the Makefile to try and build universal binaries
      ENV.refurbish_args

      # Work around issue with Makefile.PL not detecting -ltermcap
      # https://rt.cpan.org/Public/Bug/Display.html?id=133846
      inreplace "Makefile.PL", "my $TERMCAP_LIB =", "my $TERMCAP_LIB = '-lncurses'; 0 &&"

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                     "--includedir=#{Formula["readline"].opt_include}",
                     "--libdir=#{Formula["readline"].opt_lib}"
      system "make", "install"
    end

    rewrite_shebang detected_perl_shebang, "kpcli-#{version}.pl"

    libexec.install "kpcli-#{version}.pl" => "kpcli"
    chmod 0755, libexec/"kpcli"
    (bin/"kpcli").write_env_script("#{libexec}/kpcli", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system bin/"kpcli", "--help"
  end
end
