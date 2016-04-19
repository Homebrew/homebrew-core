class Libmf < Formula
  desc "open source tool for approximating an incomplete matrix."
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libmf/"
  url "http://www.csie.ntu.edu.tw/~cjlin/libmf/libmf-2.01.zip"
  sha256 "75bb98a4e8f1a318d7d07556583727b4e301759904570bf527972d964d34ef30"
  patch :DATA

  def install
    system "make"
    system "make", "lib"
    cp "./mf-predict", bin
    cp "./mf-train", bin
    cp "./libmf.so.2", lib
  end

  test do
    system "mf-predict"
  end
end
__END__
diff --git a/Makefile b/Makefile
index fcdf25f..cf379d5 100644
--- a/Makefile
+++ b/Makefile
@@ -12,13 +12,13 @@ DFLAG = -DUSESSE
 #CXXFLAGS += -mavx
 
 # uncomment the following flags if you do not want to use OpenMP
-DFLAG += -DUSEOMP
-CXXFLAGS += -fopenmp
+# DFLAG += -DUSEOMP
+# CXXFLAGS += -fopenmp
 
 all: mf-train mf-predict
 
 lib: 
-	$(CXX) -shared -Wl,-soname,libmf.so.$(SHVER) -o libmf.so.$(SHVER) mf.o 
+	$(CXX) -shared -Wl,-install_name,libmf.so.$(SHVER) -o libmf.so.$(SHVER) mf.o 
 
 mf-train: mf-train.cpp mf.o
 	$(CXX) $(CXXFLAGS) $(DFLAG) -o $@ $^
