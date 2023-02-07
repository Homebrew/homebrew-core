class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://github.com/p7zip-project/p7zip"
  url "https://github.com/p7zip-project/p7zip/archive/v17.05.tar.gz"
  sha256 "9473e324de6a87d89cb7ff65b0fec4ae3f147f03ffc138189c336a4650d74804"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd7cb7a6a46e211dc70b68c37d479aacbcdc10ff82c7ccb362568a8419bb4a02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e547edf3d09ecb55e80732926e888aa0b1b1c4e26c3c9d426ea5feb114d68933"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2b311e771e182e09c82bafd5b4022787a48dee235e119ea3951eead83679939"
    sha256 cellar: :any_skip_relocation, ventura:        "9719fb57808dfdf16c2b24d742412f5cf3c2646518ae22c670b4780f69265669"
    sha256 cellar: :any_skip_relocation, monterey:       "8965f47208c8e5fdc1311ed3e2dd577e68c0eed95bd6fd772ffa621a87597721"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e2401bb27e6fb23e7d07eff10b78ff3f3b334aedf2344ed1df89b7cc5c7940c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab12417b8f6a38cb88eb9c5c90de17844b16e3441934427a9cfe275de82e2fec"
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
