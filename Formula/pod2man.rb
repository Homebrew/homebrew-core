class Pod2man < Formula
  desc "perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-4.08.tar.xz"
  sha256 "d846e41365ebf938f35e17ad65092cd87d60caee105b065eeede3421baabe681"

  bottle do
    cellar :any_skip_relocation
    sha256 "749f02f9d7129123ef10481bbcb96bfc6b7ef65871e0d181d67b9944e19c099d" => :el_capitan
    sha256 "9d35b78b3e6b22d9411636cc6d8ef9989e7f1cb36585adc1250d2d4406f0c24d" => :yosemite
    sha256 "e8b9e6de8dd8bfac2b6da0ad02005bf6d0a734203bc0b3e0099dc28f804ada2d" => :mavericks
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
