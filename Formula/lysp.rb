class Lysp < Formula
  desc "Small Lisp interpreter"
  homepage "http://www.piumarta.com/software/lysp/"
  url "http://www.piumarta.com/software/lysp/lysp-1.1.tar.gz"
  sha256 "436a8401f8a5cc4f32108838ac89c0d132ec727239d6023b9b67468485509641"
  revision 2

  bottle do
    cellar :any
    sha256 "8b6fa4d8e69928c4f7afa9f396a2b9504b3ffd751d83b5f5636cd1e21aed1119" => :sierra
    sha256 "7d8380217d8083fe46b2c8fee9cbc287a87cd98ab9a0ed4f7d57995635a589fc" => :el_capitan
    sha256 "6c1b8f905cff7f2db24b2eecc07ff90d5a8b5e045202bcdd216da6b0f6582b9d" => :yosemite
    sha256 "8b432a319cf0596c89c69e1c43784d7700423646f0602cb48b707c055ef61b61" => :mavericks
  end

  depends_on "bdw-gc"
  depends_on "gcc"

  fails_with :clang do
    cause "use of unknown builtin '__builtin_return'"
  end

  # Use our CFLAGS
  patch :DATA

  def install
    # this option is supported only for ELF object files
    inreplace "Makefile", "-rdynamic", ""

    system "make", "CC=#{ENV.cc}"
    bin.install "lysp", "gclysp"
  end

  test do
    (testpath/"test.l").write <<-EOS.undent
      (define println (subr (dlsym "printlnSubr")))
      (define + (subr (dlsym "addSubr")))
      (println (+ 40 2))
    EOS

    assert_equal "42", shell_output("#{bin}/lysp test.l").chomp
  end
end

__END__
diff --git a/Makefile b/Makefile
index fc3f5d9..0b0e20d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,3 @@
-CFLAGS  = -O  -g -Wall
-CFLAGSO = -O3 -g -Wall -DNDEBUG
-CFLAGSs = -Os -g -Wall -DNDEBUG
 LDLIBS  = -rdynamic
 
 all : lysp gclysp
@@ -10,15 +7,15 @@ lysp : lysp.c gc.c
 	size $@
 
 olysp: lysp.c gc.c
-	$(CC) $(CFLAGSO) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
+	$(CC) $(CFLAGS) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
 	size $@
 
 ulysp: lysp.c gc.c
-	$(CC) $(CFLAGSs) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
+	$(CC) $(CFLAGS) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
 	size $@
 
 gclysp: lysp.c
-	$(CC) $(CFLAGSO) -DBDWGC=1  -o $@ lysp.c $(LDLIBS) -lgc
+	$(CC) $(CFLAGS) -DBDWGC=1  -o $@ lysp.c $(LDLIBS) -lgc
 	size $@
 
 run : all
