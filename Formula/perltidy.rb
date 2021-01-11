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
    sha256 "1199bca3ba6ecf245fcc0642a70fee090f3b12b567d86e2361af7391cae57e00" => :big_sur
    sha256 "e38bf179878203015b3eb522361df0dfa02897683c2b5aedd7c60fa5d3dc3430" => :arm64_big_sur
    sha256 "b733a78ef6180b1bc2cc182b1a267e177e931965db5d030c7651b41918b99474" => :catalina
    sha256 "98b81cb9520970e285d8249fa27d1d3cd1fcaaae8dc453a1b10c6bea1d2ab9ed" => :mojave
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
