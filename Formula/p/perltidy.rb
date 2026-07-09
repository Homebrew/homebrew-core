class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20260705/Perl-Tidy-20260705.tar.gz"
  sha256 "f766fa146041912aff48945d35e23bac39baf8051ec28e430ec25d532ca4e372"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1a5865d26a46dd51d9bfbf84597f5431c224f4e4d8e781b47cb95146c8366ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1a5865d26a46dd51d9bfbf84597f5431c224f4e4d8e781b47cb95146c8366ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1a5865d26a46dd51d9bfbf84597f5431c224f4e4d8e781b47cb95146c8366ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee9e089c8da1b4102d2e9592920c09264b4c3d8a4da4a46b0e798406150e1531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0b3c1431b4365a99e6423111beaaa74cf91452fd94ef16d61bcbd57f3d98dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e724114a344c0e256f8bcdec8bb2e078fe2648a01f49eef49144ea656441778"
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
    (testpath/"testfile.pl").write <<~PERL
      print "Help Desk -- What Editor do you use?";
      chomp($editor = <STDIN>);
      if ($editor =~ /emacs/i) {
        print "Why aren't you using vi?";
      } elsif ($editor =~ /vi/i) {
        print "Why aren't you using emacs?";
      } else {
        print "I think that's the problem";
      }
    PERL
    system bin/"perltidy", testpath/"testfile.pl"
    assert_equal <<~PERL, (testpath/"testfile.pl.tdy").read
      print "Help Desk -- What Editor do you use?";
      chomp( $editor = <STDIN> );
      if ( $editor =~ /emacs/i ) {
          print "Why aren't you using vi?";
      }
      elsif ( $editor =~ /vi/i ) {
          print "Why aren't you using emacs?";
      }
      else {
          print "I think that's the problem";
      }
    PERL
  end
end
