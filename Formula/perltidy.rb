class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20200110/Perl-Tidy-20200110.tar.gz"
  sha256 "c8c13ab88f42409d419993d488b8dc7cf4a02d5034d3037ca859fb93b18e8086"

  bottle do
    cellar :any_skip_relocation
    sha256 "05a1114d7b8f4aaee26b81970da067c80bd774554eca35d62388a19d7e190961" => :catalina
    sha256 "2bccd9c57ade5e50754a418a512fa1f31b9625b2437db0f530aca4260f1b1622" => :mojave
    sha256 "78412fec8de42607432153744cd9a6d8345b4d749fca9ec1ac1ff51b6c96209b" => :high_sierra
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
