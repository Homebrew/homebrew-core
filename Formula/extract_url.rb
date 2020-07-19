class ExtractUrl < Formula
  desc "Perl script to extracts URLs from emails or plain text"
  homepage "https://www.memoryhole.net/~kyle/extract_url/"
  url "https://github.com/m3m0ryh0l3/extracturl/archive/v1.6.2.tar.gz"
  sha256 "5f0b568d5c9449f477527b4077d8269f1f5e6d6531dfa5eb6ca72dbacab6f336"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "f25df47b8114db594552372e4ee1f9bf7337ab14996429dda0981c93c74afcfe" => :catalina
    sha256 "e8061e3ca6f23c1ae9a042960d05b8ff23887a684c6b37cc831f17fdab4936de" => :mojave
    sha256 "2880b669c381e7c7a2420d71c673d68d988223dc63bad9f14b1c62495973f362" => :high_sierra
    sha256 "57b556a225f6ec03cee7166c1b4cbd2eb1c0eb2bd7819865bd9ed39620b81b68" => :sierra
    sha256 "96d599a0f724f6f09e261c8b0a1c8bbf69ce1b199d311527636f8a5d42f197c6" => :el_capitan
    sha256 "d16fcc4c81a2ffb7f384f104396aae674bb8f6f08d336056ab858924d545f205" => :yosemite
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

    # Disable dynamic selection of perl, which may cause "Can't locate
    # Mail/Header.pm in @INC" if brew perl is picked up. If the missing modules
    # are added to the formula, mismatched perl will cause segfault instead.
    inreplace "extract_url.pl", "#!/usr/bin/env perl", "#!/usr/bin/perl"

    %w[MIME::Parser HTML::Parser Pod::Usage Env Getopt::Long Curses Curses::UI].each do |r|
      resource(r).stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    resource("URI::Find").stage do
      system "perl", "Build.PL", "--install_base", libexec
      system "./Build"
      system "./Build", "install"
    end

    system "make", "prefix=#{prefix}"
    system "make", "prefix=#{prefix}", "install"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    (testpath/"test.txt").write("Hello World!\nhttps://www.google.com\nFoo Bar")
    assert_match "https://www.google.com", pipe_output("#{bin}/extract_url -l test.txt")
  end
end
