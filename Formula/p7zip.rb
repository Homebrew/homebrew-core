class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/p7zip/p7zip/15.14.1/p7zip_15.14.1_src_all.tar.bz2"
  sha256 "699db4da3621904113e040703220abb1148dfef477b55305e2f14a4f1f8f25d4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c177274176797277173b13361c5f437721c57a4bf0bcb7c7602a50cf08cc1148" => :el_capitan
    sha256 "dba5744e40331a8f390af95e0012584ae26fca2190001ee89a9f2a6d6aa2552c" => :yosemite
    sha256 "f5994168925b3d141a8b91cd85a4f39d395674da19e8774cab1b00c6c1b63048" => :mavericks
  end

  # CVE-2016-2334 and CVE-2016-2335
  # http://www.talosintel.com/reports/TALOS-2016-0093/
  # http://www.talosintel.com/reports/TALOS-2016-0094/
  # https://packages.qa.debian.org/p/p7zip/news/20160515T102412Z.html
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/p7zip/p7zip_15.14.1+dfsg-2.debian.tar.xz"
    mirror "https://mirrors.kernel.org/debian/pool/main/p/p7zip/p7zip_15.14.1%2bdfsg-2.debian.tar.xz"
    sha256 "f4db6803535fc30b6ae9db5aabfd9f57a851c6773d72073847ec5e3731b7af37"
    apply "patches/CVE-2016-2334.patch", "patches/CVE-2016-2335.patch"
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
