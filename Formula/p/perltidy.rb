class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20240202/Perl-Tidy-20240202.tar.gz"
  sha256 "9451adde47c2713652d39b150fb3eeb3ccc702add46913e989125184cd7ec57d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0eff09e99b80d94f1a514320a2845400fe430388b3a1ff72696e4a20b0cf3c9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46969328c3fe426cabd3e289bed626896e3dfd2c28d615177154964b48d8c3a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46969328c3fe426cabd3e289bed626896e3dfd2c28d615177154964b48d8c3a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca1c6d9759b774fedd13e06455866caad3842c5b3f4d9b9ea6eb3a775f779e6d"
    sha256 cellar: :any_skip_relocation, ventura:        "01f795c4a66cb356e60f569984a028037d74f04895f39c7c5e14c74729c04787"
    sha256 cellar: :any_skip_relocation, monterey:       "01f795c4a66cb356e60f569984a028037d74f04895f39c7c5e14c74729c04787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68aceac6756fc0b8c1b397c4248be84e0c0da744406a2f44b002966d8a1c9cbe"
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
