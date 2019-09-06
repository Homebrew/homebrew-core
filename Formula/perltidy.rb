class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20190601/Perl-Tidy-20190601.tar.gz"
  sha256 "8f3d704b4eff457bf5bb70f9adf570690b2252dec31f75e8cb743392f1be338f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f73526cd1fb0bdefa05ae84ef5a0789aa31e67aba44ff7492ccec7d95242df15" => :mojave
    sha256 "39502016b8763e1c96b730a4bb1d6396efd70781e19d768b25b6601371ca4d4c" => :high_sierra
    sha256 "6e160f9dac0c0128cc097094363202f5f0feae41deee4c7e6bf63c0a125a96ae" => :sierra
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
