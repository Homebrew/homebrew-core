class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20200110/Perl-Tidy-20200110.tar.gz"
  sha256 "c8c13ab88f42409d419993d488b8dc7cf4a02d5034d3037ca859fb93b18e8086"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cef99a6ef86d9fa2c9ea2a19fdbe9e65c75fbb78238ec152d5ec3e63c897264" => :catalina
    sha256 "061afebc4d81e55cef82947d634039dabe72496d1974df35e473595c27cddd80" => :mojave
    sha256 "723099b8029e18ab21b64f063b46fb809b256d697e41ebcc1b6a02c0fef0e158" => :high_sierra
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                                  "INSTALLSITESCRIPT=#{bin}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make"
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
