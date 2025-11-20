class NotmuchMutt < Formula
  desc "Notmuch integration for Mutt"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.39.tar.xz"
  sha256 "b88bb02a76c46bad8d313fd2bb4f8e39298b51f66fcbeb304d9f80c3eef704e3"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    formula "notmuch"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b0184fde96b4d04f190604ec6140f6d72eed4457e6a26c1a1e6308521674295"
    sha256 cellar: :any,                 arm64_sequoia: "7172f1fdbe9794f01c80d042b9052d45fd7d7892cd1f9f4982b6a02b5bfa3680"
    sha256 cellar: :any,                 arm64_sonoma:  "5ee7a940df309ec27388421162a63c718cfff6f3b16354cf19c61cae3ba61a54"
    sha256 cellar: :any,                 arm64_ventura: "e45332fb4bdd1c4fd017c43fe8ec0781cbfd0f941a3ceda8c68e6ec5b7d1324d"
    sha256 cellar: :any,                 sonoma:        "04c812d8705d2fa575c954ca2a5bd01d85183414633f3d69631441e191b16929"
    sha256 cellar: :any,                 ventura:       "e445cab33c47569706ec82e94db95982c96f5685da6b099ce963ea77f5ad963a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f60737a15a2f386ba14e641f8c7a1820863d2eaf369c1c11228057a44e766b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dafb17ac7a19666854de6837b3810f8bb5d4804395c07bf7e7af94c60b91eaf"
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
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.46.tar.gz"
    sha256 "b13832132e50366c34feac12ce82837c0a9db34ca530ae5d27db97cf9c964c7b"
  end

  resource "String::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "Mail::Box::Maildir" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Box-3.010.tar.gz"
    sha256 "ae194fa250c545c9b9153e3fb5103cab29f79cf2acd4e9fd75cec532201a9564"
  end

  resource "Mail::Header" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MailTools-2.21.tar.gz"
    sha256 "4ad9bd6826b6f03a2727332466b1b7d29890c8d99a32b4b3b0a8d926ee1a44cb"
  end

  resource "Mail::Reporter" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Message-3.015.tar.gz"
    sha256 "b2858d7f877d3ed489f83404a40aaa95dd96ef61e00f141aef149a332399b25a"
  end

  resource "MIME::Types" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MIME-Types-2.26.tar.gz"
    sha256 "bc738483cb4cdb47d61e85fe9304fa929aa9ab927e3171ec2ba2ab1cd7cefdff"
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
