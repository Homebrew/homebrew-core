class ExtractUrl < Formula
  desc "Perl script to extracts URLs from emails or plain text"
  homepage "https://www.memoryhole.net/~kyle/extract_url/"
  url "https://github.com/m3m0ryh0l3/extracturl/archive/v1.6.2.tar.gz"
  sha256 "5f0b568d5c9449f477527b4077d8269f1f5e6d6531dfa5eb6ca72dbacab6f336"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6695e1a5dc10ac46acf1420064c5822095bb658a90ca1b43a1b68e769998edeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "950f85ce128891278f41aa0b2c7fcaf0cce890055be40741ed8cac6db35c0a73"
    sha256 cellar: :any_skip_relocation, monterey:       "068e50356b3f5e555dc76209629169704f1dc03cbf20a7e8f94b2ee3c884ca05"
    sha256 cellar: :any_skip_relocation, big_sur:        "1418a8148c3fbeb60fbb976b52b5fa59d3702ba5e69fe02179588ab3ba343001"
    sha256 cellar: :any_skip_relocation, catalina:       "f25df47b8114db594552372e4ee1f9bf7337ab14996429dda0981c93c74afcfe"
    sha256 cellar: :any_skip_relocation, mojave:         "e8061e3ca6f23c1ae9a042960d05b8ff23887a684c6b37cc831f17fdab4936de"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2880b669c381e7c7a2420d71c673d68d988223dc63bad9f14b1c62495973f362"
    sha256 cellar: :any_skip_relocation, sierra:         "57b556a225f6ec03cee7166c1b4cbd2eb1c0eb2bd7819865bd9ed39620b81b68"
    sha256 cellar: :any_skip_relocation, el_capitan:     "96d599a0f724f6f09e261c8b0a1c8bbf69ce1b199d311527636f8a5d42f197c6"
    sha256 cellar: :any_skip_relocation, yosemite:       "d16fcc4c81a2ffb7f384f104396aae674bb8f6f08d336056ab858924d545f205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed3da89e39498b9cf758805a920ebbb6bb4f0f14e6587b7a82f1e0ddf3beddc5"
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
