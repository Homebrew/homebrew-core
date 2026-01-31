class NotmuchMutt < Formula
  desc "Notmuch integration for Mutt"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.40.tar.xz"
  sha256 "4b4314bbf1c2029fdf793637e6c7bb15c1b1730d22be9aa04803c98c5bbc446f"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    formula "notmuch"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61ccc4f9f98e51c4287dfa1412010e03f7c3753967b57a84c614b55397dc4c7d"
    sha256 cellar: :any,                 arm64_sequoia: "211d7738abecb91e850a5c27e35ab09c02e115605cde3b8fba41b59145f70c7b"
    sha256 cellar: :any,                 arm64_sonoma:  "5601edd21ef92cefeab285aa14120038729899dbbd7c8da8801fe326bb2bdaca"
    sha256 cellar: :any,                 sonoma:        "f0af748c3b2f019836fb39cd29f53a74508536f81eb9e0f7977a01c2aca6fe65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6df1c4cdca9f0bb8b387c2dc7586998b6eaee5f436072046a2ebbd42b1362262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f9a0d7f4233730ad26a7ff0a7e300735d267b3b65fef20ea74b852ec03ed286"
  end

  depends_on "notmuch"
  depends_on "perl"
  depends_on "readline"

  uses_from_macos "ncurses"

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
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/File-Remove-1.61.tar.gz"
    sha256 "fd857f585908fc503461b9e48b3c8594e6535766bc14beb17c90ba58d5dc4975"
  end

  resource "Term::ReadLine::Gnu" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.47.tar.gz"
    sha256 "3b07ac8a9b494c50aa87a40dccab3f879b92eb9527ac0f2ded5d4743d166b649"
  end

  resource "String::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "Mail::Box::Maildir" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Box-4.01.tar.gz"
    sha256 "ad66807dd830371278c7fc31f3df9048c16ce9d01430d5fb4414feae05f1fe0d"
  end

  resource "Mail::Header" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MailTools-2.22.tar.gz"
    sha256 "3bf68bb212298fa699a52749dddff35583a74f36a92ca89c843b854f29d87c77"
  end

  resource "Mail::Reporter" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Message-4.03.tar.gz"
    sha256 "fc2f45df8a74a757bdf4fd13d342a4d013702a116425f4e2a649c1b61d15e3af"
  end

  resource "MIME::Types" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MIME-Types-2.30.tar.gz"
    sha256 "f31b1666bdf420b4b65c373ce0129ee349dd24bab4cd16c7f01b698fe450be6f"
  end

  resource "Object::Realize::Later" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Object-Realize-Later-4.00.tar.gz"
    sha256 "c4753d5a35f147eede09cdbd5e6d627dde3bdaaabfe9e56f2cff72b72d19979b"
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

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                     "--includedir=#{Formula["readline"].opt_include}",
                     "--libdir=#{Formula["readline"].opt_lib}"
      system "make", "install"
    end

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system bin/"notmuch-mutt", "search", "Homebrew"
  end
end
