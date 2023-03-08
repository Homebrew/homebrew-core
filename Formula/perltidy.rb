class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20230309/Perl-Tidy-20230309.tar.gz"
  sha256 "e22949a208c618d671a18c5829b451abbe9da0da2cddd78fdbfcb036c7361c18"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a07c1045d4dc2e1549d6db6ccd72ce5335326b37f1376383aba1d2bea39c9a93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a07c1045d4dc2e1549d6db6ccd72ce5335326b37f1376383aba1d2bea39c9a93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d733b21133f91f6d68b25fd2c64f057137b502a39082e100b22e2e4b36fd6d4"
    sha256 cellar: :any_skip_relocation, ventura:        "347568f54b469a91379d2e4ebbc206f53cf2e059ecc1e4820d44a9f7d709603e"
    sha256 cellar: :any_skip_relocation, monterey:       "347568f54b469a91379d2e4ebbc206f53cf2e059ecc1e4820d44a9f7d709603e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b91d4ccbceec326c54583426acbfc71500754009ccbdc5e03f9ea4e17bfcba03"
    sha256 cellar: :any_skip_relocation, catalina:       "770c2d57739f78c6ab6f215a633cbeff3f4ffcc5c81f90aebdff96d7e0b0011b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adf90332e05e74930267a0a4b348d1a1809698c7917ba3ae58991940ace57180"
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
