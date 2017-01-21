class ExtractUrl < Formula
  desc "Perl script to extracts URLs from emails or plain text."
  homepage "http://www.memoryhole.net/~kyle/extract_url/"
  url "https://github.com/m3m0ryh0l3/extracturl/archive/v1.6.1.tar.gz"
  sha256 "6ce3a977477cce6c7c8355500db4ef660d5b22118df6534d3ab022124c62a393"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf5df7ceb341dcc4a2662b47de98a52311d027d562a8be49756c13de70982907" => :sierra
    sha256 "798e74f8b8f742ac15f99086a6491e5958316461a2d3a664f8a405f23a4ea938" => :el_capitan
    sha256 "76b29261c92fd1d0b0575f91c0dec7d0142465097593f96882fa34be9e48b90f" => :yosemite
    sha256 "55c1a2bd5b6f71eadaf2eba18623268b87e7019a25dd670077f90cd7ccbd032a" => :mavericks
    sha256 "2bfe029ac91f5cfa70440ed9b65f7996fd7e199d5f286bd4c5958757b79d0909" => :mountain_lion
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

  # Remove for > 1.6.1
  # Fix test failure "Can't locate sys/ioctl.ph in @INC (did you run h2ph?)"
  # Upstream commit from 19 Jan 2017 "ioctl.ph is not often installed; do a
  # better job of loading modules for term size detection"
  patch do
    url "https://github.com/m3m0ryh0l3/extracturl/commit/fad68f2.patch"
    sha256 "cccd76d73afd9e5fbb98a9685dba27c15311671de3cf4388829f43f230b13698"
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
