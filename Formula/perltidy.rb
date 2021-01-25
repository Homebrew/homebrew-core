class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20210111/Perl-Tidy-20210111.tar.gz"
  sha256 "207666ceaf5d4eaf7a608c8f4a77f212cae811bb88ce159c33e2d8a0b5da189f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b2faf9f6bad9fd3057e64235d9e21b3ccdc43142e32e82dc6bfa1ef87d1c49dd" => :big_sur
    sha256 "54e4729027c5da8ce8cd34b6d85e4a148984fc6ab7525f8433a4d660e8001bc6" => :arm64_big_sur
    sha256 "160dc31f00f4bdb67ee28102c8e44497d1d2ac2e364edd822e9ee7e4275a61cf" => :catalina
    sha256 "c1a7f1eb5fccd061b53c88312e4573302d3ea0b7a443aa7addae078cc1e5251c" => :mojave
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
