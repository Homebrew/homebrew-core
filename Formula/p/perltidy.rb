class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20260808/Perl-Tidy-20260808.tar.gz"
  sha256 "038277b43eddd2cb702e8058ca3ff685b3d64e6662361e7ad2158ccfd07291be"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15a69f989f6d316abb6efd6e2aff7661b8689651ccfa32a5a175dfc4d589da80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15a69f989f6d316abb6efd6e2aff7661b8689651ccfa32a5a175dfc4d589da80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15a69f989f6d316abb6efd6e2aff7661b8689651ccfa32a5a175dfc4d589da80"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ce4242877009763e7922a9619ecd5e0dfcc5e1beea3e3d5773447b35bfbe406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "091f7edd17a5f90b0215fc283454a389d2d10e517697b89a7e3deb9d177b1939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b61c89f7cd8d112e74c3d4be2ad03e448fce71ee1f67e44001fcf7c2f569145a"
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
