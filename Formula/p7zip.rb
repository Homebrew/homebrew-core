class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/p7zip/p7zip/15.14.1/p7zip_15.14.1_src_all.tar.bz2"
  sha256 "699db4da3621904113e040703220abb1148dfef477b55305e2f14a4f1f8f25d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "c177274176797277173b13361c5f437721c57a4bf0bcb7c7602a50cf08cc1148" => :el_capitan
    sha256 "dba5744e40331a8f390af95e0012584ae26fca2190001ee89a9f2a6d6aa2552c" => :yosemite
    sha256 "f5994168925b3d141a8b91cd85a4f39d395674da19e8774cab1b00c6c1b63048" => :mavericks
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
end
