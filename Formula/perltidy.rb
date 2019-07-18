class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20190601/Perl-Tidy-20190601.tar.gz"
  sha256 "8f3d704b4eff457bf5bb70f9adf570690b2252dec31f75e8cb743392f1be338f"

  bottle do
    cellar :any_skip_relocation
    sha256 "3eea0c9c4f72dfe772301c153a0aaed43105020086cda3721b785389bd3515ce" => :mojave
    sha256 "74062f9591fa421b637127521c7aa79b140d7741042671a1f21d2148cb50c3f0" => :high_sierra
    sha256 "62a1de49e77f4214b8f689c74f0b5de888e6df0d2e51741d2e5650c2df09ed02" => :sierra
    sha256 "ed1fbd3fcb92487349a6d5431a32f1c9824ce63ecce9e7d2d9371636da42a3a6" => :el_capitan
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                                  "INSTALLSITESCRIPT=#{bin}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make"
    system "make", "test"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
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
