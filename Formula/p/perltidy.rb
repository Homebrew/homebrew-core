class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20250311/Perl-Tidy-20250311.tar.gz"
  sha256 "7fc6ceda4e3c9fc79c777afbcf8d167ecc35b16ff81c9cbeaf727b15d0502d8a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "502111e4bf98e0a250df10e6484e19659445c33caaed5405363b4c024a8844ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "502111e4bf98e0a250df10e6484e19659445c33caaed5405363b4c024a8844ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21b06e9daad00a6bebddda0650227633c82aa5e3bcb7b0f7111915b8d0733bde"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f327e270db665ac52f0227cc4d71f6af5dda2964725956ee22e7f0e5cc37838"
    sha256 cellar: :any_skip_relocation, ventura:       "088a45ef5f7a47039f72b1dfeb94ad23f446807bbaa593c31e4eacf6baad4cb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b7b2bd46e00f58ab89441f3848db04ff3bdf2363d7ad7d32625bd2f4720a872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a48bbaa91035f33ccb1cdc50935d79f812e598c456c472ff0ff7b9365a0e41"
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
