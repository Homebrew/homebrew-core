class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://github.com/p7zip-project/p7zip"
  url "https://github.com/p7zip-project/p7zip/archive/refs/tags/v17.06.tar.gz"
  sha256 "c35640020e8f044b425d9c18e1808ff9206dc7caf77c9720f57eb0849d714cd1"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2490c82b53fc8b7c05e11e5f365f525dea28ce760b58d71eee5e5f263e3bdbbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "369d3a03a92f93bac16dd14b0a0bdfdd89ca55acbd503a5df2e6bb5db090570a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23da67120f4a22b34c56bf6ab2cae4283088eb5ad1a78a79addbb4a2a499f7c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f660dc57664af754240e077dd1ed79f78505f40d62ca41630955d0320590a75e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a651dc223abae92cec444770d67518606edadc976386a7a27da977ee680f7fd"
    sha256 cellar: :any_skip_relocation, ventura:       "593e544721a4c420f0eb97987f51778b56cc643c7dd7ae4a287489bd01bd167a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1355071d140bc9e5b5f6453fa5352e5e378bb9abcbd7361ee8c9e06893ce3d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ba01da665c3009888c57246945052cd4bfac19007fe0dd9d9b705152089076"
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
