class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20201202/Perl-Tidy-20201202.tar.gz"
  sha256 "20a5e4bd0bbb4a20f4d611eec08679bbac00c8b8ba03f4deda646f8ea1770b64"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3e016e0476db2b9bc47c2a2c44c75caa891cc58eb078c511121aac527a7c56d4" => :big_sur
    sha256 "f4c7d493dd160f77a4eb9ffdaae1dba253eb5002dae7b61fe7f0f75be2be3aae" => :catalina
    sha256 "516bf53ef6b995a20875522dfd13cf2746fbf90739d6b82da41e8d1b50d24685" => :mojave
    sha256 "5d4762a60cd52cbd73e4fc1d0d67ace8595bd6133958b16ef2c4093491bff545" => :high_sierra
  end

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
