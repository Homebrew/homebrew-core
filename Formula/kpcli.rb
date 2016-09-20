class Kpcli < Formula
  desc "command-line interface to KeePass database files"
  homepage "http://kpcli.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/kpcli/kpcli-3.1.pl"
  sha256 "f1f07704a30d0eae126717d5dae0d24ccced43c316454e4a7b868fe0a239a21a"
  revision 1

  bottle do
    cellar :any
    sha256 "4427a30d0628659873487af0d06d1c03bc2258039c079d1a68c9007eb0a49baa" => :sierra
    sha256 "9b209cfefdd8951bbc2adbb7daaf0140833d255151dc3b0539a4ed468d1d3e42" => :el_capitan
    sha256 "c3f46b3afa9b23c9d28206ddcac5e18f60c6c3117e99eda51dee26351eae30be" => :yosemite
  end

  depends_on "readline"

  resource "File::KeePass" do
    url "https://cpan.metacpan.org/authors/id/R/RH/RHANDOM/File-KeePass-2.03.tar.gz"
    sha256 "c30c688027a52ff4f58cd69d6d8ef35472a7cf106d4ce94eb73a796ba7c7ffa7"
  end

  resource "Crypt::Rijndael" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Crypt-Rijndael-1.13.tar.gz"
    sha256 "cd7209a6dfe0a3dc8caffe1aa2233b0e6effec7572d76a7a93feefffe636214e"
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
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.34.tar.gz"
    sha256 "a965fd0601bea84cb65e0c5e6a1eb3469fe2d99772be235faccbc49c57edf6cd"
  end

  resource "Data::Password" do
    url "https://cpan.metacpan.org/authors/id/R/RA/RAZINF/Data-Password-1.12.tar.gz"
    sha256 "830cde81741ff384385412e16faba55745a54a7cc019dd23d7ed4f05d551a961"
  end

  resource "Clipboard" do
    url "https://cpan.metacpan.org/authors/id/K/KI/KING/Clipboard-0.13.tar.gz"
    sha256 "eebf1c9cb2484be850abdae017147967cf47f8ccd99293771517674b0046ec8a"
  end

  resource "Mac::Pasteboard" do
    url "https://cpan.metacpan.org/authors/id/W/WY/WYANT/Mac-Pasteboard-0.008.tar.gz"
    sha256 "62e5f55c423d033f8f5caff5d1678bb0b327144655aeaeb48a11cf633baa8f15"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.44.tar.gz"
    sha256 "3ad2bb950a112c282a90018e91e60ddc4c4d2d351de2869d46a8c3db5b611160"
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
      args = %W[
        INSTALL_BASE=#{libexec}
        --includedir=#{Formula["readline"].opt_include}
        --libdir=#{Formula["readline"].opt_lib}
      ]
      system "perl", "Makefile.PL", *args
      system "make", "install"
    end

    libexec.install "kpcli-#{version}.pl" => "kpcli"
    chmod 0755, libexec/"kpcli"
    (bin/"kpcli").write_env_script("#{libexec}/kpcli", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system bin/"kpcli", "--help"
  end
end
