class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20220613/Perl-Tidy-20220613.tar.gz"
  sha256 "50496a6952904ef28f495919fc0a67801a63c87779c61308ce1ca5b32467c5d4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9627f41bf8e466818ef5272f588d910a878f6da9cb4287f6eee93e492f909444"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ef92cc0bb057fb2f6b3fd56012963a5b3c80ff5755aa3ef6d19b7e3e018485b"
    sha256 cellar: :any_skip_relocation, monterey:       "57f3c639784b348b99459021fd8dd9fe9b63fbd6fb4198bada81c6146485a965"
    sha256 cellar: :any_skip_relocation, big_sur:        "985be977badd26e808312a119cfcfc7cf163ce5a1b6839be7081de55e6ed547e"
    sha256 cellar: :any_skip_relocation, catalina:       "f447a679f46cbf822bffa482b1c15a18207e322e615a6ec601e8dbbac3ae3cea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9014e6abc321ee2eab46e3e6c146eec3d4afd389d6ea1010e8183d3aa39766be"
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
