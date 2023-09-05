class NotmuchMutt < Formula
  desc "Notmuch integration for Mutt"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.37.tar.xz"
  sha256 "0e766df28b78bf4eb8235626ab1f52f04f1e366649325a8ce8d3c908602786f6"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    formula "notmuch"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9a61e5677f06d1a354c7768d824a67fee4142a363c03331a78e152d0c4a2004d"
    sha256 cellar: :any,                 arm64_monterey: "fe70dc43e3db8da7cda11364cccf84b00d4ea31e6f430e8cf086928437431f72"
    sha256 cellar: :any,                 arm64_big_sur:  "d3c29fa91e5251cd84d7954878e37f3f53c83505c28079c32841cd9047f2dd6c"
    sha256 cellar: :any,                 ventura:        "e989f65e8a6859330ca2bf82df16656d367b1b6d1d47c929f01fd1040fdf536f"
    sha256 cellar: :any,                 monterey:       "88b138b05fd875d3cd94feae70bfeadc2b7506142ed58723d0a237b9db5bf95b"
    sha256 cellar: :any,                 big_sur:        "79208cd497a43ac2b284b1b93080039d5d3bcf8338786d039779311694d0c57a"
    sha256 cellar: :any,                 catalina:       "9f752552f320e607b87c513b6427cb64daed813b60b0ce2f45ec6fe505c432e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b10a1926b83286823c6ec7e07a17d8d531a4d1f477fbb4edaceee7d0290c916"
  end

  depends_on "notmuch"
  depends_on "readline"

  uses_from_macos "perl"

  on_linux do
    resource "Date::Parse" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
      sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
    end

    resource "IO::Lines" do
      url "https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/IO-Stringy-2.113.tar.gz"
      sha256 "51220fcaf9f66a639b69d251d7b0757bf4202f4f9debd45bdd341a6aca62fe4e"
    end

    resource "Devel::GlobalDestruction" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Devel-GlobalDestruction-0.14.tar.gz"
      sha256 "34b8a5f29991311468fe6913cadaba75fd5d2b0b3ee3bb41fe5b53efab9154ab"
    end

    resource "Sub::Exporter::Progressive" do
      url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
      sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
    end

    resource "File::Remove" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/File-Remove-1.60.tar.gz"
      sha256 "e86e2a40ffedc6d5697d071503fd6ba14a5f9b8220af3af022110d8e724f8ca6"
    end
  end

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
