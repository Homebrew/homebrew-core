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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9961eb5988d5ef0a72957f5dff0d3797429cd823e91050bd92beec246c44db62"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b856d782c45d129da7b6308722e0658b81a1229179e64a7506d6685c6a01354"
    sha256 cellar: :any_skip_relocation, catalina:      "6e0bbd48c43054d724310decf24934ec04a8474a655997a5ad41fc4f2734f91a"
    sha256 cellar: :any_skip_relocation, mojave:        "b3aeef16e90081421cb98359f106da72412be36183ecf513acfe688b55bdf964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13240ae192e791e4d720c54adb9fc4735976a06c0272ab17725ff83eb3a48454"
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
