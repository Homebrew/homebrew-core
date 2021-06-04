class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20210402/Perl-Tidy-20210402.tar.gz"
  sha256 "b6e9c75d4c8e6047fb5c2e9c60f3ea1cc5783ffde389ef90832d1965b345e663"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66ec39c4ff26ef42418ad381648c8c917f7da87e3adb743fa9892446c4e4dfa2"
    sha256 cellar: :any_skip_relocation, big_sur:       "60d13965fa91eb3587527c26509080f11f84afdc27db7a7e105a59e4cc9c660a"
    sha256 cellar: :any_skip_relocation, catalina:      "965bded37a52b58c544b3d98e9dd15d5b7ea06a1a1996cc91501cf466d7cabf7"
    sha256 cellar: :any_skip_relocation, mojave:        "6b4018956b07dbcdacf35920d1cc64c0a997f22ead747d64b730b26aac1a93f1"
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
