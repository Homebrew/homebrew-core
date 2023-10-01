class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20230912/Perl-Tidy-20230912.tar.gz"
  sha256 "0c57888f206f987777e16640e72574aa0a777846719f8e3ed0413c35325f5540"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c667375f7988908cf6e9c2b6ecafb6c5ffb5cb9a9690798f0e34a6c09428349"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c667375f7988908cf6e9c2b6ecafb6c5ffb5cb9a9690798f0e34a6c09428349"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4523f4830d52ce521ec77fbc529e8a2e0dae2c2e2bfe20e41fba598027ad0da"
    sha256 cellar: :any_skip_relocation, ventura:        "7c863ef461459d004f282a5381d88684fbec1a51dacbb30749601a1330bdb98a"
    sha256 cellar: :any_skip_relocation, monterey:       "7c863ef461459d004f282a5381d88684fbec1a51dacbb30749601a1330bdb98a"
    sha256 cellar: :any_skip_relocation, big_sur:        "50475dbbc21d7f2fa06d2bf1b5a8437449a2e385d7441d1d1554f12684c81392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56859cbd10c355ffda54e970d436d011bae8870aa1872c37dfe47be563af6353"
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
