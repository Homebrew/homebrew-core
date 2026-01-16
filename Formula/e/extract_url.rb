class ExtractUrl < Formula
  desc "Perl script to extracts URLs from emails or plain text"
  homepage "https://www.memoryhole.net/~kyle/extract_url/"
  url "https://github.com/m3m0ryh0l3/extracturl/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "5f0b568d5c9449f477527b4077d8269f1f5e6d6531dfa5eb6ca72dbacab6f336"
  license "BSD-2-Clause"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "160fbf5e75d447edf2f1769a1d4960906df27652a6849d19ac122689102b47ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a565d71f29f03e9160f187615c545935db2ae098ebb8aff901932d8579500d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2a3eb7fe036307b921324ba71eead19534b37c3bbb47f16481d76c1fdb13b29"
    sha256 cellar: :any_skip_relocation, tahoe:         "eb0760f5c01a362d6f704fcf1e005d38f3a41228dbc041072bfb6927c0fb74de"
    sha256 cellar: :any_skip_relocation, sequoia:       "b4726e6215dc76ad8f1cf403618557361379644780e0727feb9e65a241ad3d24"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1a9b40af8d79f7c0db5d3bcd88ddebf0e2bccf6c7057a189d189af6cd12765f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fb17c0cf4ed6894006819a6d8df16b1657fd6bda55626bc4201d2350048c3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b82abb25a1f169aa7ae9507c37283fd2d0586447b877e1ca5973dd1535fa3152"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_linux do
    # URI::Find -> Module::Build (build-only)
    resource "Module::Build" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
      sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
    end

    # URI::Find -> URI -> MIME::Base32
    resource "MIME::Base32" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/MIME-Base32-1.303.tar.gz"
      sha256 "ab21fa99130e33a0aff6cdb596f647e5e565d207d634ba2ef06bdbef50424e99"
    end

    # URI::Find -> URI
    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.29.tar.gz"
      sha256 "a34b9f626c3ff1e20c0d4a23ec5c8b7ae1de1fb674ecefed7e46791388137372"
    end

    # MIME::Parser -> Mail::Internet -> Date::Format
    resource "Date::Format" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
      sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
    end

    # MIME::Parser -> Mail::Internet
    resource "Mail::Internet" do
      url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MailTools-2.21.tar.gz"
      sha256 "4ad9bd6826b6f03a2727332466b1b7d29890c8d99a32b4b3b0a8d926ee1a44cb"
    end

    # HTML::Parser -> HTML::Tagset
    resource "HTML::Tagset" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz"
      sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
    end

    # HTML::Parser -> HTTP::Headers -> Clone
    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.47.tar.gz"
      sha256 "4c2c0cb9a483efbf970cb1a75b2ca75b0e18cb84bcb5c09624f86e26b09c211d"
    end

    # HTML::Parser -> HTTP::Headers -> Encode::Locale
    resource "Encode::Locale" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end

    # HTML::Parser -> HTTP::Headers -> HTTP::Date
    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
      sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
    end

    # HTML::Parser -> HTTP::Headers -> IO::HTML
    resource "IO::HTML" do
      url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
      sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
    end

    # HTML::Parser -> HTTP::Headers -> LWP::MediaTypes
    resource "LWP::MediaTypes" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
      sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
    end

    # HTML::Parser -> HTTP::Headers
    resource "HTTP::Headers" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.46.tar.gz"
      sha256 "e27443434150d2d1259bb1e5c964429f61559b0ae34b5713090481994936e2a5"
    end

    # Curses::UI -> Term::ReadKey
    resource "Term::ReadKey" do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  resource "MIME::Parser" do
    url "https://cpan.metacpan.org/authors/id/D/DS/DSKOLL/MIME-tools-5.515.tar.gz"
    sha256 "c1ba1dd9f0b2cd82a0e75caedec51e48233f9f01dc29a0971bdff1cb53be9013"
  end

  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.83.tar.gz"
    sha256 "7278ce9791256132b26a71a5719451844704bb9674b58302c3486df43584f8c0"
  end

  resource "Getopt::Long" do
    url "https://cpan.metacpan.org/authors/id/J/JV/JV/Getopt-Long-2.58.tar.gz"
    sha256 "1305ed46ea21f794304e97aa3dcd3a38519059785e9db7415daf2c218506c569"
  end

  resource "URI::Find" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSCHWERN/URI-Find-20160806.tar.gz"
    sha256 "e213a425a51b5f55324211f37909d78749d0bacdea259ba51a9855d0d19663d6"
  end

  # Curses::UI -> Curses
  resource "Curses" do
    url "https://cpan.metacpan.org/authors/id/G/GI/GIRAFFED/Curses-1.45.tar.gz"
    sha256 "84221e0013a2d64a0bae6a32bb44b1ae5734d2cb0465fb89af3e3abd6e05aeb2"
  end

  resource "Curses::UI" do
    url "https://cpan.metacpan.org/authors/id/M/MD/MDXI/Curses-UI-0.9609.tar.gz"
    sha256 "0ab827a513b6e14403184fb065a8ea1d2ebda122d2178cbf45c781f311240eaf"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"
    ENV["PERL_MM_USE_DEFAULT"] = "1"

    resources.each do |r|
      r.stage do
        if File.exist? "Makefile.PL"
          with_env(PERL_USE_UNSAFE_INC: nil) do
            # https://rt.cpan.org/Public/Bug/Display.html?id=121041
            ENV["PERL_USE_UNSAFE_INC"] = "1" if r.name == "Curses::UI"

            system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          end
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
