class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20201001/Perl-Tidy-20201001.tar.gz"
  sha256 "0873ebb300239d792fb8e67164b0e04bb8fb1ff153659630d321c0b4a1dc9a12"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "240c8e2c88b1e25dc272ffd842e11954b6d59e2525778473efd182ca79c91700" => :catalina
    sha256 "f8d51c96d8669b691b94ea813bb1a4abdae133f1e161f4e72ecfcc8923231244" => :mojave
    sha256 "c0c6d266728fabe3991a7ff17d3cc36eac4533f3ce6fa9476347f473592f69da" => :high_sierra
  end

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
