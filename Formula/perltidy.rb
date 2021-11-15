class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20211029/Perl-Tidy-20211029.tar.gz"
  sha256 "ec03b1e36a57d094569a30082688f722253401c7cc934ac64d2e3eb4de880eda"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76001def7996868b78e0f26a6f67565d38a41f1d8608d68007854ffa021075f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a558352491ac875616d9cbc078ff121f11959a6380d4fd6e5da8b510d2e3213c"
    sha256 cellar: :any_skip_relocation, monterey:       "3668f063a2ede54b1ba5f338b7fc28692b59ff1b0274e7c9620c7257b2ad5c8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "adb8b3a0b935922bb430c23b3d57f0e0502cf55cbdcca1faf0b7c583ae6ae8ce"
    sha256 cellar: :any_skip_relocation, catalina:       "0ce92bd06855674d04a9f895d265be5a01c9fd09ecfa8a39567a23ef21dcca43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cd1d340feaaade089dc7346a28bf04ee05761eef80d45df4aa2900bbeba51f1"
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
    (testpath/"testfile.pl").write <<~EOS
      print "Help Desk -- What Editor do you use?";
      chomp($editor = <STDIN>);
      if ($editor =~ /emacs/i) {
        print "Why aren't you using vi?\n";
      } elsif ($editor =~ /vi/i) {
        print "Why aren't you using emacs?\n";
      } else {
        print "I think that's the problem\n";
      }
    EOS
    system bin/"perltidy", testpath/"testfile.pl"
    assert_predicate testpath/"testfile.pl.tdy", :exist?
  end
end
