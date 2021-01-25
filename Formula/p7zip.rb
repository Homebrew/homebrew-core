class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://p7zip.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2"
  sha256 "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 3

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "910811e37db23bbe76d169211d31d36156403f503654d04ed612d7863ea907f8" => :big_sur
    sha256 "672dff61eba151f9c1117a1486ef2908dc0d834c355ca31f359ac56dafc75e3d" => :arm64_big_sur
    sha256 "82e0e2a437f8f2e58e82d4823bfaeb479e89d325af3bd4300ab349a5b09fa132" => :catalina
    sha256 "971a247c66fae4b54fdf169fdea79b79a85af6a8d6dc01a3119df014aa4316fe" => :mojave
  end

  # Fix security bugs and remove non-free RAR sources
  patch do
    url "https://deb.debian.org/debian/pool/main/p/p7zip/p7zip_16.02+dfsg-8.debian.tar.xz"
    sha256 "01217dca1667af0de48935a51dc46aad442e6ebcac799d714101b7edf9651eb5"
    apply "patches/01-makefile.patch",
          "patches/12-CVE-2016-9296.patch",
          "patches/13-CVE-2017-17969.patch"
  end

  # Fix AES security bugs
  patch :p4 do
    url "https://github.com/aonez/Keka/files/2940620/15-Enhanced-encryption-strength.patch.zip"
    sha256 "838dd2175c3112dc34193e99b8414d1dc1b2b20b861bdde0df2b32dbf59d1ce4"
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
