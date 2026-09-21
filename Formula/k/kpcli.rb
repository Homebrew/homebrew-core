class Kpcli < Formula
  desc "Command-line interface to KeePass database files"
  homepage "https://kpcli.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/kpcli/kpcli-4.1.3.pl"
  sha256 "c91363e4e07f3521a867f68db602c95b53dc167e4366ee7ff254252b4176c62f"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/kpcli[._-]v?(\d+(?:\.\d+)+)\.pl}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e1c9015e6bae196f284393624e2cbab15f1dde99bd052f290ab30042ed7e8954"
    sha256 cellar: :any, arm64_tahoe:       "ef1bdb8f3ce84f2ad240d1f35b01078f10335681bb997a29723cbbc62248a3f4"
    sha256 cellar: :any, arm64_sequoia:     "d97d19bdd97f231d2fe2843fab67760583fb97a39bfc8c3d4530ace29eecaf34"
    sha256 cellar: :any, arm64_linux:       "a0e600b5481b43071d2e156898ed6840f1776268ae63cd12f3404ca3f99025f0"
    sha256 cellar: :any, x86_64_linux:      "85c7bfb89f3a3f9e61025cd117f6bdeefd9d952b6fa1e0316b689514e8764f08"
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
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Clipboard-0.31.tar.gz"
    sha256 "af6dc25cf8299d3ed612a2182d0c98e7a011f12ac5f6634c1e9180d3204c2cd8"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.50.tar.gz"
    sha256 "ca6e8d7ce7471c2be54e1009f64c367d7ee233a2894cacf52ebe6f53b04e81e5"
  end

  # Catch the macOS clipboard driver dying at import (no pasteboard server) in the optional-module loader
  # TODO: report upstream at https://sourceforge.net/p/kpcli/patches/ and add `resolves`
  patch :DATA

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
                     "--includedir=#{formula_opt_include("readline")}",
                     "--libdir=#{formula_opt_lib("readline")}"
      system "make", "install"
    end

    libexec.install "kpcli-#{version}.pl" => "kpcli"
    chmod 0755, libexec/"kpcli"
    (bin/"kpcli").write_env_script(libexec/"kpcli", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system bin/"kpcli", "--help"
  end
end

__END__
--- a/kpcli-4.1.3.pl
+++ b/kpcli-4.1.3.pl
@@ -8853,7 +8853,8 @@
   my $eval_result = eval("require $module; 1;");
   if (! defined($eval_result)) { $eval_result = 0; }
   if ($eval_result == 1 && is_loaded($module)) {
-    my $import_result = $module->import(@{$rImportList});
+    my $import_result = eval { $module->import(@{$rImportList}); 1 }
+      or do { warn $@; $rOPTIONAL_PM->{$module}->{loaded} = 0; return 0 };
     $rOPTIONAL_PM->{$module}->{loaded} = 1;
     return 1;
   } else {
