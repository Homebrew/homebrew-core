class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://github.com/jinfeihan57/p7zip"
  url "https://github.com/jinfeihan57/p7zip/archive/v17.03.tar.gz"
  sha256 "bb4b9b21584c0e076e0b4b2705af0dbe7ac19d378aa7f09a79da33a5b3293187"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d14cc7a098606e902b3bfcb908d71a658e6b78c64adccdc93ae87a0c9f1bfd87"
    sha256 cellar: :any_skip_relocation, big_sur:       "696fae5d82319db27d8460c09bfcaa238b2af1f3741575317b4bb010d93cc90d"
    sha256 cellar: :any_skip_relocation, catalina:      "f6b8e20d8f659449c9ee8b9793c78a6bfbf5e1eb990865721b91fd7a2e7e21cc"
    sha256 cellar: :any_skip_relocation, mojave:        "b5d486a4b47f49eae90b1255a002219fc5f5e8236202333dc84d99a4529cc104"
  end

  # Remove non-free RAR sources
  patch :DATA

  # Fix AES security bugs
  # https://github.com/jinfeihan57/p7zip/pull/117
  patch do
    url "https://github.com/jinfeihan57/p7zip/commit/6106df26ff64fa8147bfc9abdc0a14908b5d3871.patch?full_index=1"
    sha256 "5fcce7293ba017b4aa3ba5afbe6f2a847d60a785ea0966c31ac33da4bdf3ef6e"
  end

  def install
    on_macos do
      mv "makefile.macosx_llvm_64bits", "makefile.machine"
    end
    on_linux do
      mv "makefile.linux_any_cpu", "makefile.machine"
    end
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
