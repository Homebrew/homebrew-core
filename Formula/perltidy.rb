class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20230309/Perl-Tidy-20230309.tar.gz"
  sha256 "e22949a208c618d671a18c5829b451abbe9da0da2cddd78fdbfcb036c7361c18"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e98550c060b38ac2f2df3cd0c1db318179bef75b29b304a09a0580d9b447a212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e98550c060b38ac2f2df3cd0c1db318179bef75b29b304a09a0580d9b447a212"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdf165bb479b8e1182dba1d7ee461d9dcefc16d83f6cc6c5d24aed617c68ad33"
    sha256 cellar: :any_skip_relocation, ventura:        "e622a6ca45098a4ede4e01bde2d0787ad64abf8393bce3ad9cc605f1b70185ae"
    sha256 cellar: :any_skip_relocation, monterey:       "e622a6ca45098a4ede4e01bde2d0787ad64abf8393bce3ad9cc605f1b70185ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f9a378bbb6df8a6437d02c7001cb81f3bfe1a3cb45c27c3f719b7752a76c5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "263bbb931ab6be17c7f5a839688296454f7d2b3fa3ab7d2308354154934b86c2"
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
