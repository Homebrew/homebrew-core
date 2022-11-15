class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://github.com/jinfeihan57/p7zip"
  url "https://github.com/jinfeihan57/p7zip/archive/v17.04.tar.gz"
  sha256 "ea029a2e21d2d6ad0a156f6679bd66836204aa78148a4c5e498fe682e77127ef"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d17d4a6968342f2addc96fa7a4caff23b86c461c27f0d40ec4fc0533f1d6a274"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b411a180788d3702feb447c95a24fba571277c8708db22929ff4a98e269ed5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1e2497a5256b9211572534456bb7271c9d04d10fc2e12599b95e0ddf4f1991b"
    sha256 cellar: :any_skip_relocation, ventura:        "ec92eb1a0daceacf356e85ef4cc56d461b5458e7e247fb14552dc6a2a6c8ebae"
    sha256 cellar: :any_skip_relocation, monterey:       "63427747e339024f690bdffeac4848e8e46cc17c6189713054b130725a00b43c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4d62f05f0cba984aa6b5712debc4f7d3b2c3bece0c503633a588cb209c911c2"
    sha256 cellar: :any_skip_relocation, catalina:       "bea86999db7dee5f0cb78d3a72d875d822ec73ebb2a6e7d46cf27ae66243c645"
    sha256 cellar: :any_skip_relocation, mojave:         "1484f0f3a0a4812dccb5f388c6671a7e524b001872b0df6d7cabc160c2f03989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d996780ca46e35a641f5f37284d19490cb5e0a990c9369045e92ba463d99430a"
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
