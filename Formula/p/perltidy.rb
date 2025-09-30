class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20250912/Perl-Tidy-20250912.tar.gz"
  sha256 "b48ee48835fbceab2fde0f1c59c5a539f046e3bb236fa34d8b60871fd79cf0a4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87c7fb65d9974f2e41df73d93962b8c63de3c1d90a7e09b4b7271d2fcfc884b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87c7fb65d9974f2e41df73d93962b8c63de3c1d90a7e09b4b7271d2fcfc884b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87c7fb65d9974f2e41df73d93962b8c63de3c1d90a7e09b4b7271d2fcfc884b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f44e71e3b2017c82d171db7123a3c4c8b45c3f24aff5bf235c21ba505e2caf4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "860a20eb27cbe64eb1eddf93704c7db881c3051d773d12aca84afbe2f7af5daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88b3a58bb564e6e42c231a8a1cc4077824252a68658a54d1e6bc59650a20f5ee"
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
