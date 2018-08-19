class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://p7zip.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2"
  sha256 "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "bb715042a9067df735cd7d032a15988da430fbf5a297d9624b9a4a021af6fea2" => :mojave
    sha256 "fb52fc214eb4ecd032666997976a514212adcb3c33ca23f15547310d5dc14a6e" => :high_sierra
    sha256 "a2b914eebce9108f278e33b53ca798999eb81397c370bd1eaa7f63ddc5e51867" => :sierra
    sha256 "229fc3a0badd5325e69b93121c9d55e7860110093e57ef46af063daccb2af372" => :el_capitan
  end

  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/p7zip/p7zip_16.02+dfsg-6.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/p/p7zip/p7zip_16.02+dfsg-6.debian.tar.xz"
    sha256 "fab0be1764efdbde1804072f1daa833de4e11ea65f718ad141a592404162643c"
    apply "patches/12-CVE-2016-9296.patch",
          "patches/13-CVE-2017-17969.patch"
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
