class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20240903/Perl-Tidy-20240903.tar.gz"
  sha256 "22fba4ba84cf2ba5fb4ade3ae65c6deb48a0ee61fe446858d3ae8c5e00f37e81"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bb8899ed668a66a1cf0b1b81d9fa9b3dcb456925b47a8da0312d8dfdaa9336da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb8899ed668a66a1cf0b1b81d9fa9b3dcb456925b47a8da0312d8dfdaa9336da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3163c8cd853f61f071145fe936c1aefe3690e2fa1c6e162054c46d45ae60446b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3163c8cd853f61f071145fe936c1aefe3690e2fa1c6e162054c46d45ae60446b"
    sha256 cellar: :any_skip_relocation, sonoma:         "37004c7bca8ec46163442d76e7599b17acba936b4dad26f53fbf4ca578669b78"
    sha256 cellar: :any_skip_relocation, ventura:        "a0edd728a606f2404c8e72186accf24e5feafb239feeb0ced28da1e823246f03"
    sha256 cellar: :any_skip_relocation, monterey:       "a0edd728a606f2404c8e72186accf24e5feafb239feeb0ced28da1e823246f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74e8a657dd5facba5abd7ee9bb5b1f475be8a8d6f8031368f4cdb0c4b3e2f27e"
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
