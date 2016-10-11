class Pod2man < Formula
  desc "perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-4.08.tar.xz"
  sha256 "d846e41365ebf938f35e17ad65092cd87d60caee105b065eeede3421baabe681"

  bottle do
    cellar :any_skip_relocation
    sha256 "c98c2c6c9a2d53467b3f4c80291724022c68e55e5508d52b7245d0e3d8f4dc33" => :sierra
    sha256 "e86e356803bd92e2b283a0b89dc09520469fb2fad833b7141369f7af0dbe3a1a" => :el_capitan
    sha256 "876f5b1f7728a2129fd0edb3312de07801f646da736900198757ecd5cb848e29" => :yosemite
  end

  keg_only :provided_by_osx

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}",
                   "INSTALLSCRIPT=#{bin}",
                   "INSTALLMAN1DIR=#{man1}", "INSTALLMAN3DIR=#{man3}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.pod").write "=head2 Test heading\n"
    manpage = shell_output("#{bin}/pod2man #{testpath}/test.pod")
    assert_match '.SS "Test heading"', manpage
  end
end
