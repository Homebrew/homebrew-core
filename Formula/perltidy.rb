class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20220613/Perl-Tidy-20220613.tar.gz"
  sha256 "50496a6952904ef28f495919fc0a67801a63c87779c61308ce1ca5b32467c5d4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a6f839401d29d45c877fa479e5fe205ff83797663b7463f480343bbb2ce4e75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "036599d0496cea185b2afb15ce9e4b720cc9f4ff93fa534f91e7b2d431091b7b"
    sha256 cellar: :any_skip_relocation, monterey:       "3e3aa5b804fe15bb415812628756db253b0d0ecf7f8978923d2cf84efe877240"
    sha256 cellar: :any_skip_relocation, big_sur:        "a130ee5632843b72c6217dfaa71c758d0b9b8fb63f794df638e87aa32dd8070c"
    sha256 cellar: :any_skip_relocation, catalina:       "a54e50b3b596db82c4654202936fd376c0db415172adfedba42b1b2f28d5eb2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05cc61fdad984047b80e0b9519e4e7a7afa694879fa8958b350827c8a01b9901"
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
