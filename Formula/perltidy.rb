class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20221112/Perl-Tidy-20221112.tar.gz"
  sha256 "8e3fffbaadb5612ff2c66742641838cf403ff1ed11091f5f5d72a8eb61c4bfa8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f39d3eda57667b6349ce3aa2a484517cadefa2ae10087ebb9eda0eeb47149767"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f39d3eda57667b6349ce3aa2a484517cadefa2ae10087ebb9eda0eeb47149767"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aeb6b365bc1db132eeec7b37a3eda21abf5ff9d8f380f11120addf96c30b1cc"
    sha256 cellar: :any_skip_relocation, monterey:       "374fba984abb02546d3d384907f24ac65505d2581f4c91cc6110fd61857567ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "8340d207df0dcecc30e2bc3eb91ec87c2f2cf870d08888b37f12291ea64a0d8b"
    sha256 cellar: :any_skip_relocation, catalina:       "16eb37fdf7c7ffaf3d59a8ae29202ce28dfdf34488ddb329c953a903b5160195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1291c0e97f2f792816d0a40f2909957c755bdaebaaf073e1d1caee6b437b2ead"
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
