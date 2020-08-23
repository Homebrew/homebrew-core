class NotmuchMutt < Formula
  desc "Notmuch integration for Mutt"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.30.tar.xz"
  sha256 "5e3baa6fe11d65c67e26ae488be11b320bae04e336acc9c64621f7e3449096fa"
  license "GPL-3.0"
  head "https://git.notmuchmail.org/git/notmuch", using: :git

  bottle do
    cellar :any
    sha256 "a3f8a11f72c219bcc2f6eb0c6e8a5a1b5656e3364257e45c1716a8bf685fa412" => :catalina
    sha256 "a31991d286a3d3aaf904c49100c7379ca44c0802fbaa62e222d897a157576ff0" => :mojave
    sha256 "7774d94c0fae96c5dd3d0ea1a71c0f3f9d230b507f4759756bbb9ddebd25dfa9" => :high_sierra
  end

  depends_on "readline"

  uses_from_macos "perl"
  uses_from_macos "pod2man"

  resource "Term::ReadLine::Gnu" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.36.tar.gz"
    sha256 "9a08f7a4013c9b865541c10dbba1210779eb9128b961250b746d26702bab6925"
  end

  resource "String::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "Mail::Box::Maildir" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Box-3.008.tar.gz"
    sha256 "b51a50945db1335503e1414d76dcc74e669c4179ea07852f9800b270d5c0d297"
  end

  resource "Mail::Header" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MailTools-2.21.tar.gz"
    sha256 "4ad9bd6826b6f03a2727332466b1b7d29890c8d99a32b4b3b0a8d926ee1a44cb"
  end

  resource "Mail::Reporter" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Message-3.009.tar.gz"
    sha256 "39d2cf98a24f786c119ff04df9b44662970bc2110d1bc6ad33ba64c06d97cf1a"
  end

  resource "MIME::Types" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MIME-Types-2.17.tar.gz"
    sha256 "e04ed7d42f1ff3150a303805f2689c28f80b92c511784d4641cb7f040d3e8ff6"
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
    system "#{bin}/notmuch-mutt", "search", "Homebrew"
  end
end
