class Mvptree < Formula
  desc "Perceptual hash library"
  homepage "http://www.phash.org"
  url "http://www.phash.org/releases/mvptree-1.0.tar.gz"
  sha256 "cbb89e7368785f4823200d4ba81975cdabe77797d736047b1ea14b02e6a61839"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b8719298ad63a89f6d3aad4dd8d613aef88618f0ba98ada1215f7c93e331baea" => :sierra
    sha256 "aba4177b187d549958f160ba5f6699f0532396a43b593a9a7bef456e68ae939b" => :el_capitan
    sha256 "6e96d7c146df25acc913aefdd421202d978d77c70cfc75d2f8da5cb59c078c8a" => :mavericks
  end

  # Patch submitted to upstream by mail
  # Fixes a "permission denied" problem in the Makefile
  patch :DATA

  def install
    lib.mkpath
    include.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <mvptree.h>
      int main() {
        MVPDP *pt = dp_alloc(MVP_BYTEARRAY);
        dp_free(pt, (MVPFreeFunc)0);
        return 0;
      }
    EOS
    system ENV.cc, "-g", "-c", "test.c", "-o", "test.o"
    system ENV.cc, "-g", "test.o", "#{lib}/libmvptree.a", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/Makefile b/Makefile
index bb155e2..29876b1 100644
--- a/Makefile
+++ b/Makefile
@@ -43,8 +43,9 @@ clean :

 install : $(HFLS) $(LIBRARY)
	install -c -m 444 $(HFLS) $(DESTDIR)/include
-	install -c -m 444 $(LIBRARY) $(DESTDIR)/lib
+	install -c -m 644 $(LIBRARY) $(DESTDIR)/lib
	$(RANLIB) $(DESTDIR)/lib/$(LIBRARY)
+	chmod 444 $(DESTDIR)/lib/$(LIBRARY)

 $(LIBRARY) : $(OBJS)
	ar cr $(LIBRARY) $?
