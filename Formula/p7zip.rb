class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://github.com/p7zip-project/p7zip"
  url "https://github.com/p7zip-project/p7zip/archive/v17.05.tar.gz"
  sha256 "d2788f892571058c08d27095c22154579dfefb807ebe357d145ab2ddddefb1a6"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6513bd9bfcd09b10daaee0c6a932c81e26b312ef3c3c9c0e5365032c830a4a9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf24dc934ed3ed7af833d8209bf051ea7d3633883dd2124312daeeee7f05979e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "957996e3f011b38d511ad7a6cc276a90befb4a81a73ac7b11f6a60727f3c7970"
    sha256 cellar: :any_skip_relocation, ventura:        "972d07a3d845624cdd5ec397b1632a51e6c679b0b6b31130a5ec29a8cb51d9d5"
    sha256 cellar: :any_skip_relocation, monterey:       "dc0a43db9ec4a64bab1ef02fc8dd73c63bec2eda9d74b2efb408b7b126f37d49"
    sha256 cellar: :any_skip_relocation, big_sur:        "df7d89c12a8d9c0d3499ddba4ef4cd0cd606a86b00578a6b15ea3e03b7969449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f710f7278c964390af99b4fd4776a3054aed68952acaebc98e725e8b9a638c21"
  end

  # Remove non-free RAR sources
  patch :DATA

  def install
    if OS.mac?
      mv "makefile.macosx_llvm_64bits", "makefile.machine"
    else
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
