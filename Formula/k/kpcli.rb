require "language/perl"

class Kpcli < Formula
  include Language::Perl::Shebang

  desc "Command-line interface to KeePass database files"
  homepage "https://kpcli.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/kpcli/kpcli-4.1.pl"
  sha256 "dedf0e86f44f8f7a1a9c524a45a515846945d01e04f9402571f18c22971eb7db"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/kpcli[._-]v?(\d+(?:\.\d+)+)\.pl}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7bc0ef59d9caec5c48f47b609a4d36e1305a88cac6f9ebdeb33cb20be4867c4"
    sha256 cellar: :any,                 arm64_ventura:  "f22469e7f9b815ea840b6e9e796247728dfdbf1a5de884bcc202f285436412c9"
    sha256 cellar: :any,                 arm64_monterey: "45723b6731c390994768c83d514d63a462e25152f596803637e37b4973718560"
    sha256 cellar: :any,                 sonoma:         "6054435c1158b36b1845b3b563f8e3bf3d6d284166346155e0e92985f45aa28e"
    sha256 cellar: :any,                 ventura:        "0ab43cd7b8d801b481d3d80d33ea56e4ec6e31e13eff468fe917a0fc014325e0"
    sha256 cellar: :any,                 monterey:       "4cb0734bb1a2e7889535858462c1cb352f13de0177d0083273f982b6f0ef826f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51769e2425233df85bd8e2bf47921e1669587df47889b2419c14164d3325f576"
  end

  depends_on "readline"

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  resource "Mac::Pasteboard" do
    on_macos do
      url "https://cpan.metacpan.org/authors/id/W/WY/WYANT/Mac-Pasteboard-0.104.tar.gz"
      sha256 "c55a4431188bec4873212a7c308f835fd1f0e3ba1958173037b5e2d0100fca40"

      # fix incompatible pointer error, upstream pr ref, https://github.com/trwyant/perl-Mac-Pasteboard/pull/5
      patch do
        url "https://github.com/trwyant/perl-Mac-Pasteboard/commit/0d5537e912409429d565e9b755e9e4e9c125fc55.patch?full_index=1"
        sha256 "feae9fd03d694440d73b0ace29bd4c18788015ac51a7aa797f97d501567d613b"
      end
    end
  end

  resource "Clone" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Clone-0.46.tar.gz"
      sha256 "aadeed5e4c8bd6bbdf68c0dd0066cb513e16ab9e5b4382dc4a0aafd55890697b"
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
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Clipboard-0.29.tar.gz"
    sha256 "7eea786eb401ab7f6651e50dc5ea0b26431112a14353ed0fdb2307bac241aaea"
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
