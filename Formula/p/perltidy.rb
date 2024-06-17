class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20240511/Perl-Tidy-20240511.tar.gz"
  sha256 "47ff9e8ce98b5a43dc2d9ce4f02b9af3f4824a5fd912473edc9c16dc595468f2"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccfd56687aada1e59e20f0535782fc68fee5ad362aac6b239e53b1ba83b9eda5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8608329221a2f773f80375df057784f7b85c671ec7fe3940a8af6fe6544275a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf15ac2e6c436b9ab7abd526ba17cf4b97e336f5ae31a8a853884dee8936d30c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddf4c0f5a2672dbbb0f3a449ae0665bd42669c60eec2d933e1620d62c7aa1258"
    sha256 cellar: :any_skip_relocation, ventura:        "c6dd06f10cba883c5ad8ebf0c14d080fdb2629892393364909dbd00d496db3e3"
    sha256 cellar: :any_skip_relocation, monterey:       "7364f7d166f859ba99ed385b4f4364be83bb39475ca88a38bcd8101443039175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a70ac233909a39e812aef7e945aeafd0e0cb119992a61a6d264d6a5c681c3334"
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
