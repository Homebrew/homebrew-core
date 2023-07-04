class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20230701/Perl-Tidy-20230701.tar.gz"
  sha256 "e04922ba34a0c0c8dca7d6897a70399e1b1358441f66d3abd0f021a413869743"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2baa88eb66068fe80bd0d21eadbdb37a0c2d8040f363028cf34fa1102bafd38d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2baa88eb66068fe80bd0d21eadbdb37a0c2d8040f363028cf34fa1102bafd38d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3712cc2f73ef65af02c1614605bb4ecacb8b859be414ff998359cefd8086543"
    sha256 cellar: :any_skip_relocation, ventura:        "dca53a649e44861660cda665a20d878fe7c71071ac51cdfdaa84422c7398d8d8"
    sha256 cellar: :any_skip_relocation, monterey:       "dca53a649e44861660cda665a20d878fe7c71071ac51cdfdaa84422c7398d8d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "89b39502c2562080271056845553768dfa690869fcb6cd8d61788592b6a21fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a67c87894b9108d481f38ccde1fac60707e777cf2101029f3515ccd032abd499"
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
