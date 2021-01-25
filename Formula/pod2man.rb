class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-4.14.tar.xz"
  sha256 "e504c3d9772b538d7ea31ce2c5e7a562d64a5b7f7c26277b1d7a0de1f6acfdf4"
  revision 1

  livecheck do
    url "https://archives.eyrie.org/software/perl/"
    regex(/href=.*?podlators[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f25e1faab4a26b64026c5f84a62ec47f03c3291e8449382ad37d7b124bd4e9f4" => :big_sur
    sha256 "4f555cd902868cdb36c0e723876e576f73b597effee5cbfd669ca7a00dba1f2b" => :arm64_big_sur
    sha256 "2c2eed3a6018e17e0ad345e605e36772ff606f2cb70a611604d4b98a9e96defd" => :catalina
    sha256 "2569545e8e290c5281b72067276779c281be303caac9151c250194e15db5ed19" => :mojave
  end

  keg_only :provided_by_macos

  def install
    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}",
                   "INSTALLSITEMAN1DIR=#{man1}", "INSTALLSITEMAN3DIR=#{man3}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.pod").write "=head2 Test heading\n"
    manpage = shell_output("#{bin}/pod2man #{testpath}/test.pod")
    assert_match '.SS "Test heading"', manpage
  end
end
