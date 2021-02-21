class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://github.com/jinfeihan57/p7zip"
  url "https://github.com/jinfeihan57/p7zip/archive/v17.03.tar.gz"
  sha256 "bb4b9b21584c0e076e0b4b2705af0dbe7ac19d378aa7f09a79da33a5b3293187"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "672dff61eba151f9c1117a1486ef2908dc0d834c355ca31f359ac56dafc75e3d"
    sha256 cellar: :any_skip_relocation, big_sur:       "910811e37db23bbe76d169211d31d36156403f503654d04ed612d7863ea907f8"
    sha256 cellar: :any_skip_relocation, catalina:      "82e0e2a437f8f2e58e82d4823bfaeb479e89d325af3bd4300ab349a5b09fa132"
    sha256 cellar: :any_skip_relocation, mojave:        "971a247c66fae4b54fdf169fdea79b79a85af6a8d6dc01a3119df014aa4316fe"
  end

  # Remove non-free RAR sources
  patch :DATA

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

__END__
diff -u -r a/makefile b/makefile
--- a/makefile	2021-02-21 14:27:14.000000000 +0800
+++ b/makefile	2021-02-21 14:27:31.000000000 +0800
@@ -31,7 +31,6 @@
 	$(MAKE) -C CPP/7zip/UI/Client7z           depend
 	$(MAKE) -C CPP/7zip/UI/Console            depend
 	$(MAKE) -C CPP/7zip/Bundles/Format7zFree  depend
-	$(MAKE) -C CPP/7zip/Compress/Rar          depend
 	$(MAKE) -C CPP/7zip/UI/GUI                depend
 	$(MAKE) -C CPP/7zip/UI/FileManager        depend
 
@@ -42,7 +41,6 @@
 common7z:common
 	$(MKDIR) bin/Codecs
 	$(MAKE) -C CPP/7zip/Bundles/Format7zFree all
-	$(MAKE) -C CPP/7zip/Compress/Rar         all
 
 lzham:common
 	$(MKDIR) bin/Codecs
@@ -67,7 +65,6 @@
 	$(MAKE) -C CPP/7zip/UI/FileManager       clean
 	$(MAKE) -C CPP/7zip/UI/GUI               clean
 	$(MAKE) -C CPP/7zip/Bundles/Format7zFree clean
-	$(MAKE) -C CPP/7zip/Compress/Rar         clean
 	$(MAKE) -C CPP/7zip/Compress/Lzham       clean
 	$(MAKE) -C CPP/7zip/Bundles/LzmaCon      clean2
 	$(MAKE) -C CPP/7zip/Bundles/AloneGCOV    clean
