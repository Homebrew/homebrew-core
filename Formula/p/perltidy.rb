class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20250711/Perl-Tidy-20250711.tar.gz"
  sha256 "347aa90bcefbde2b590daf48d387ef1fd9b7a73a996b040269f11ab6fb8ba448"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b748cb7033651de878ac5ca6de091abbd87bca61041f28f6e5cd38f06437f8a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b748cb7033651de878ac5ca6de091abbd87bca61041f28f6e5cd38f06437f8a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa4dc54757306928be38ea61919c738f6c5c932d7f4fb6179826667141c0bf51"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dff9fd45152bee6c945e8d4a4644263d8659e7333d6083240c4218fc8286bc0"
    sha256 cellar: :any_skip_relocation, ventura:       "c717758af025f5fbcec639ac8122e542a3af35a1649e2505944c7cf05d2a1675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89180806b8d38b67feae773dc10e0b30a76d8833baa5547b65ccba757e7de903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6489a45437753dbf0dc0c2477c6318985f959dd748481e327466bd599fd9cb95"
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
