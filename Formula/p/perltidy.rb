class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20260204/Perl-Tidy-20260204.tar.gz"
  sha256 "56a1fc2f1f813e49026a0f284b9209a6b2824620993e7598c85b01c444ff0f64"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ca7f622d92c873e5c1b1a4973f52cc56531ff6daed23168f70f7790b82a9985"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ca7f622d92c873e5c1b1a4973f52cc56531ff6daed23168f70f7790b82a9985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ca7f622d92c873e5c1b1a4973f52cc56531ff6daed23168f70f7790b82a9985"
    sha256 cellar: :any_skip_relocation, sonoma:        "78aa30f7606cbb0be494e7cafa3431257d24140bf8e2f0968d230792a452c1df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "888b618d4883d7d9915a737bb9fd90c25aa519f574c799b2e96fb45efc032d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4904b0b9f2ff96f3df306c931bda053f6aa9d447d79751ef871496e1fc6b2f0e"
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
