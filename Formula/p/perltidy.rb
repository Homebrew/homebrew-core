class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20250105/Perl-Tidy-20250105.tar.gz"
  sha256 "d2cea2b909da69ab6d09f00dcb27cd9551184a5e4267d825da15d2f52e228632"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f18a0a155689a2f7120df199c4a192dd24a5867126d86036d7dafb6842974fa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f18a0a155689a2f7120df199c4a192dd24a5867126d86036d7dafb6842974fa8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab241177e3253e48bd4da7303acb9f08c44c8331a81c7716b0d9ea389890dbee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c21a8f764cfac1c8e3d4749df751353c522932281fbf835432a416aeb5243de6"
    sha256 cellar: :any_skip_relocation, ventura:       "59bd9d24b6ceeb2dd4f74918ddb2fe1f90d1e158a9f3050358e12d8d67945717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d7f2df85debb185b949a113126df9a3fe7b7c85ff02538593559055919ea132"
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
