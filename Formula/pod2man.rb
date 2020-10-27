class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-4.14.tar.xz"
  sha256 "e504c3d9772b538d7ea31ce2c5e7a562d64a5b7f7c26277b1d7a0de1f6acfdf4"

  livecheck do
    url "https://archives.eyrie.org/software/perl/"
    regex(/href=.*?podlators[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3befc44e77ae00da3acfe5f42a579ebc01ce376dde402404aa5496caaa81d572" => :catalina
    sha256 "8ba154647a2c2e44cce5251c0172fdb85ad51a7a6fd7f738dfcad9c30de1214d" => :mojave
    sha256 "bdff3cadfd2c7a5b017c82501b21c69865ce352d0044daafa07c294fac0865e6" => :high_sierra
  end

  keg_only :provided_by_macos

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
