require "language/perl"

class Kpcli < Formula
  include Language::Perl::Shebang

  desc "Command-line interface to KeePass database files"
  homepage "https://kpcli.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/kpcli/kpcli-3.7.pl"
  sha256 "8c12566c292650451590ba42aba48f117eb60d786aed4309cca19febd4d2d673"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/kpcli[._-]v?(\d+(?:\.\d+)+)\.pl}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fb2334f285e2e66f31bf4cd5d7087fa09fd7d98bb163854bf376a8e51f509926"
    sha256 cellar: :any,                 arm64_big_sur:  "9b87bc1033d73c01bf5f72d05c9647d51b4f814f1f0ab6c685b570d795be50df"
    sha256 cellar: :any,                 monterey:       "d23ea3b4ac917951959fde61c4d923e79f47ee031ae86cba5c3e624cc667cc84"
    sha256 cellar: :any,                 big_sur:        "f6b94c8937a6827ed804d66412fb4e2c1cf4d791c902a8a4ba3c73714b92fcc9"
    sha256 cellar: :any,                 catalina:       "286c50adf94e56ef0e71fe440c0bc24f9f4b0e7f7f41b4a61c445e723e3b297a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae9172060c3823a69b5dca9fe83eef8ae7a0c0f978d26821f3961ed418095b4a"
  end

  depends_on "readline"

  uses_from_macos "perl"

  on_macos do
    resource "Mac::Pasteboard" do
      url "https://cpan.metacpan.org/authors/id/W/WY/WYANT/Mac-Pasteboard-0.103.tar.gz"
      sha256 "2f5e8dd2db0d6445558484ca6d42d839c5a97ee8aa1b250e694d67d5b7f6634c"
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
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.42.tar.gz"
    sha256 "3c5f1281da2666777af0f34de0289564e6faa823aea54f3945c74c98e95a5e73"
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
