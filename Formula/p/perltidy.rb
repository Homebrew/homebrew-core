class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20260109/Perl-Tidy-20260109.tar.gz"
  sha256 "76404514505ba0c768a394d4f28ea0691c8899b049258aa545b7042265e14811"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3218253f6cd5a019e6e31d4a5530d7af029b2f1b64f5ee3f9ee56a5f8fd8cf98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3218253f6cd5a019e6e31d4a5530d7af029b2f1b64f5ee3f9ee56a5f8fd8cf98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3218253f6cd5a019e6e31d4a5530d7af029b2f1b64f5ee3f9ee56a5f8fd8cf98"
    sha256 cellar: :any_skip_relocation, sonoma:        "73f2ba2f2fa59ab846feb002d3335b25cab40b636596ad0ddf9632d855389a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e32e6ba1ef0d6ccc880cabe5ffa8b5c4dd8ff1adf9df28217776a9ee1e228f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "622929cb6881a3ce8991c5b54978fbe187555a9c2f83e32fb5963c4158bdd48f"
  end

  uses_from_macos "perl"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                                  "INSTALLSITESCRIPT=#{bin}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    (testpath/"testfile.pl").write <<~PERL
      print "Help Desk -- What Editor do you use?";
      chomp($editor = <STDIN>);
      if ($editor =~ /emacs/i) {
        print "Why aren't you using vi?";
      } elsif ($editor =~ /vi/i) {
        print "Why aren't you using emacs?";
      } else {
        print "I think that's the problem";
      }
    PERL
    system bin/"perltidy", testpath/"testfile.pl"
    assert_equal <<~PERL, (testpath/"testfile.pl.tdy").read
      print "Help Desk -- What Editor do you use?";
      chomp( $editor = <STDIN> );
      if ( $editor =~ /emacs/i ) {
          print "Why aren't you using vi?";
      }
      elsif ( $editor =~ /vi/i ) {
          print "Why aren't you using emacs?";
      }
      else {
          print "I think that's the problem";
      }
    PERL
  end
end
