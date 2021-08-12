class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20210717/Perl-Tidy-20210717.tar.gz"
  sha256 "4d1bd38e1c3a39a2fabb2ddf61a57e3d6cf2778a7b2aebcbf618ad205972cf14"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9edc9a821a8e2f328c762335e4894aa89d8f7b88581f2f978863d03609b770c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ddf621becd4af56097f4bdf2d3d9c1098cae8c5c56fc7f5daf5cd66f88e985a8"
    sha256 cellar: :any_skip_relocation, catalina:      "c84935b3b18530692c91f59941e094a212d736f13e5e2e8f6f51b91e9e6cda59"
    sha256 cellar: :any_skip_relocation, mojave:        "e5a3e554fa0f765e4ea678c541a93423a62ba4db5614b3937e28f062e1b687ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45d415c3bd44f071c5aa4d465446f6c4b0ad58e30941d59b8ed027f1e0b6c634"
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
