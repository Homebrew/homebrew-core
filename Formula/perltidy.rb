class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20190915/Perl-Tidy-20190915.tar.gz"
  sha256 "c236dfacbba115cfc3f2868006c8601e021fe97c13cd2170a49bf8d404cc701b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6a6c2d5d9cb8d87eda99bb05ab1d4cc0afc4eafb6cdc9765f0e275dbb4010d3" => :catalina
    sha256 "d93079fafa5beacbed053cf21cb96ae095d084c71def53b0d74d27b364514d5a" => :mojave
    sha256 "6c5d11263079c58ebf55bd6c4339d6086ecbaab0db0f179243ebb98c657e1f2e" => :high_sierra
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
