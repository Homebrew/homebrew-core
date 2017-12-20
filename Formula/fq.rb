class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.10.8.tar.gz"
  sha256 "b7d1886b027cf3a29c341d0fa900ff5804011035c3864352001c1d164670214c"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "3703eaf59778ef9cc3466e7532a50831a4cb9c7a8d68ad2ec703e2916e7efadd" => :high_sierra
    sha256 "5f0a3d0263c80f8f623b201103cf4262213a21f355ace7037b02145a0d0d3242" => :sierra
    sha256 "cf379add9665e48776c6083ec15f8e7d7c0e2036a072d9a04dae109550eb7242" => :el_capitan
    sha256 "508d82d68e29891fbcc027761f9cdea6e157822460c8ba5bbcf8819b15679acb" => :yosemite
  end

  depends_on "concurrencykit"
  depends_on :java => "1.8"
  depends_on "jlog"
  depends_on "openssl"

  patch :DATA

  def install
    inreplace "Makefile", "/usr/lib/dtrace", "#{lib}/dtrace"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
    bin.install "fqc", "fq_sndr", "fq_rcvr"
  end

  test do
    pid = fork { exec sbin/"fqd", "-D", "-c", testpath/"test.sqlite" }
    sleep 1
    begin
      assert_match /Circonus Fq Operational Dashboard/, shell_output("curl 127.0.0.1:8765")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/Makefile b/Makefile
index 5dbd8d1..b0a3b0b 100644
--- a/Makefile
+++ b/Makefile
@@ -134,7 +134,7 @@ fqc:	$(FQC_OBJ)
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(FQC_OBJ) $(LIBS)
 
 fq-sample.so:	$(FQD_SAMPLE_OBJ)
-	$(Q)$(MODULELD) $(EXTRA_SHLDFLAGS) $(SHLDFLAGS) -o $@ $(FQD_SAMPLE_OBJ)
+	$(Q)$(MODULELD) $(EXTRA_SHLDFLAGS) $(SHLDFLAGS) -o $@ $(FQD_SAMPLE_OBJ) $(CLIENT_OBJ_LO)
 
 fq_sndr:	fq_sndr.o libfq.a
 	@echo " - linking $@"

