class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2"
  sha256 "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5846fe05ef2dfa854a7c0a11412e1aab3245b032fbf94d289a65fca1bdfd421" => :sierra
    sha256 "7c43699b4c1c186d1dfccb2246ed8c8a9175c5c57ba211b0774395335edce2c8" => :el_capitan
    sha256 "1b3a075e34531a09c8714e92499726d4df8c082c29b43e2b11b35d6d20934627" => :yosemite
    sha256 "78981de13a763ab595e073360e2848ca0ad65d9a13b7f7728e0c255945cdd00e" => :mavericks
  end

  def install
    mv "makefile.macosx_llvm_64bits", "makefile.machine"
    system "make", "all3",
                   "CC=#{ENV.cc} $(ALLFLAGS)",
                   "CXX=#{ENV.cxx} $(ALLFLAGS)"
    system "make", "DEST_HOME=#{prefix}",
                   "DEST_MAN=#{man}",
                   "install"
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7z", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7z", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", File.read(testpath/"out/foo.txt")
  end
end
