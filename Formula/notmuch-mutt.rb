class NotmuchMutt < Formula
  desc "Notmuch integration for Mutt"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.31.4.tar.xz"
  sha256 "8661b66567660fd630af10c4647c30327fdd1b34a988cab80d614328a5b74f55"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fa40637028973e773db35f68452157b6db2fcfa9e78d094ee621ae404b39378d"
    sha256 cellar: :any, big_sur:       "50102305f751aa81344c6ee74463d4a7ed4931da790c7c518b4244e34d424fd0"
    sha256 cellar: :any, catalina:      "6d872acb64af2a755ab6303534ac9b94b289053ccc04de0fd6fe5df498dd1502"
    sha256 cellar: :any, mojave:        "be03e8e0f1ab57b0cb37c2b58173ac6d43fa70e34779799aeae85f7d29cd6819"
  end

  depends_on "notmuch"
  depends_on "readline"

  uses_from_macos "perl"
  uses_from_macos "pod2man"

  resource "Term::ReadLine::Gnu" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.37.tar.gz"
    sha256 "3bd31a998a9c14748ee553aed3e6b888ec47ff57c07fc5beafb04a38a72f0078"
  end

  resource "String::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "Mail::Box::Maildir" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Box-3.009.tar.gz"
    sha256 "9185216b0e14c919ec2384769525559491ed7d56d27adb1bc985a1fbeb799165"
  end

  resource "Mail::Header" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MailTools-2.21.tar.gz"
    sha256 "4ad9bd6826b6f03a2727332466b1b7d29890c8d99a32b4b3b0a8d926ee1a44cb"
  end

  resource "Mail::Reporter" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Message-3.010.tar.gz"
    sha256 "58414b1ae382988153a915d317245d89dd450f186ecf6d383c964b3673a78b13"
  end

  resource "MIME::Types" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MIME-Types-2.18.tar.gz"
    sha256 "31ca35a41f2ae998ccd7d33c19e42023ee6540fd9ded619b9abd48ff06a095be"
  end

  resource "Object::Realize::Later" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Object-Realize-Later-0.21.tar.gz"
    sha256 "8f7b9640cc8e34ea92bcf6c01049a03c145e0eb46e562275e28dddd3a8d6d8d9"
  end

  def install
    system "make", "V=1", "prefix=#{prefix}", "-C", "contrib/notmuch-mutt", "install"

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      next if r.name.eql? "Term::ReadLine::Gnu"

      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    resource("Term::ReadLine::Gnu").stage do
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

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system "#{bin}/notmuch-mutt", "search", "Homebrew"
  end
end
