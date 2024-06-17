class ExtractUrl < Formula
  desc "Perl script to extracts URLs from emails or plain text"
  homepage "https://www.memoryhole.net/~kyle/extract_url/"
  url "https://github.com/m3m0ryh0l3/extracturl/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "5f0b568d5c9449f477527b4077d8269f1f5e6d6531dfa5eb6ca72dbacab6f336"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fbcf24dcd91a69b5f8df429b98a735c2227e7fb6563c7bb487f40fc8f434de6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04be0c8d96101e5200f1a27a4acc69406d365cd890365583b42d40ec6945d6de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ba8599dd1ea5209f84290c6f0f904e04962681c5c84311dfea7b63a7f8aacc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "701cc9b1995de5d6b84996b5319f5f596864c3ef06fddd2408ac470c16215c0b"
    sha256 cellar: :any_skip_relocation, ventura:        "a70f7a9fe4bf2cb3c21a88686c306d1c1f38fca1e2a12af4f0aa3debc603110b"
    sha256 cellar: :any_skip_relocation, monterey:       "7eb00e81607e9e53ebd8e2d07eee49a09070bc76071705ee0ff51cfad5927b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c78463b54407c3c65b81c26270e36bb31b3be1788734f97e7e918ad8f0bc0bb"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_linux do
    resource "YAML::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.73.tar.gz"
      sha256 "bc315fa12e8f1e3ee5e2f430d90b708a5dc7e47c867dba8dce3a6b8fbe257744"
    end

    resource "Module::Install" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Module-Install-1.19.tar.gz"
      sha256 "1a53a78ddf3ab9e3c03fc5e354b436319a944cba4281baf0b904fa932a13011b"
    end

    resource "Module::Build" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz"
      sha256 "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717"
    end

    resource "Mail::Header" do
      url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MailTools-2.21.tar.gz"
      sha256 "4ad9bd6826b6f03a2727332466b1b7d29890c8d99a32b4b3b0a8d926ee1a44cb"
    end

    resource "Date::Format" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
      sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
    end
  end

  resource "MIME::Parser" do
    url "https://cpan.metacpan.org/authors/id/D/DS/DSKOLL/MIME-tools-5.508.tar.gz"
    sha256 "adffe86cd0b045d5a1553f48e72e89b9834fbda4f334c98215995b98cb17c917"
  end

  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTML-Parser-3.72.tar.gz"
    sha256 "ec28c7e1d9e67c45eca197077f7cdc41ead1bb4c538c7f02a3296a4bb92f608b"
  end

  resource "Pod::Usage" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Usage-1.69.tar.gz"
    sha256 "1a920c067b3c905b72291a76efcdf1935ba5423ab0187b9a5a63cfc930965132"
  end

  resource "Env" do
    url "https://cpan.metacpan.org/authors/id/F/FL/FLORA/Env-1.04.tar.gz"
    sha256 "d94a3d412df246afdc31a2199cbd8ae915167a3f4684f7b7014ce1200251ebb0"
  end

  resource "Getopt::Long" do
    url "https://cpan.metacpan.org/authors/id/J/JV/JV/Getopt-Long-2.49.1.tar.gz"
    sha256 "98fad4235509aa24608d9ef895b5c60fe2acd2bca70ebdf1acaf6824e17a882f"
  end

  resource "URI::Find" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSCHWERN/URI-Find-20160806.tar.gz"
    sha256 "e213a425a51b5f55324211f37909d78749d0bacdea259ba51a9855d0d19663d6"
  end

  resource "Curses" do
    url "https://cpan.metacpan.org/authors/id/G/GI/GIRAFFED/Curses-1.36.tar.gz"
    sha256 "a414795ba031c5918c70279fe534fee594a96ec4b0c78f44ce453090796add64"
  end

  resource "Curses::UI" do
    url "https://cpan.metacpan.org/authors/id/M/MD/MDXI/Curses-UI-0.9609.tar.gz"
    sha256 "0ab827a513b6e14403184fb065a8ea1d2ebda122d2178cbf45c781f311240eaf"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"
    ENV["PERL_MM_USE_DEFAULT"] = "1"

    # Disable dynamic selection of perl, which may cause "Can't locate
    # Mail/Header.pm in @INC" if brew perl is picked up. If the missing modules
    # are added to the formula, mismatched perl will cause segfault instead.
    perl = OS.mac? ? "/usr/bin/perl" : Formula["perl"].opt_bin/"perl"
    inreplace "extract_url.pl", "#!/usr/bin/env perl", "#!#{perl}"

    resources.each do |r|
      r.stage do
        if File.exist? "Makefile.PL"
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system "./Build"
          system "./Build", "install"
        end
      end
    end

    system "make", "prefix=#{prefix}"
    system "make", "prefix=#{prefix}", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    (testpath/"test.txt").write("Hello World!\nhttps://www.google.com\nFoo Bar")
    assert_match "https://www.google.com", pipe_output("#{bin}/extract_url -l test.txt")
  end
end
