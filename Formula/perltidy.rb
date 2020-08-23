class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20200619/Perl-Tidy-20200619.tar.gz"
  sha256 "03b0e1b777c95920053d37942d6398a56b746d7c78090d522371138785c8a09e"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e74edc072defecc70cfeac14f6344c0008c8c457f120a377cad20326d7f80e90" => :catalina
    sha256 "eb9955c2edb97b5a401a62bda71329e6dead46d357b0357a8761a649bd062e01" => :mojave
    sha256 "e33764a067c1b6b7a2ac4b7f05ca7e4f8aab036f2c80964c9f38c3bb0095e0a4" => :high_sierra
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
