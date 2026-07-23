class Direvent < Formula
  desc "Monitors events in the file system directories"
  homepage "https://www.gnu.org.ua/software/direvent/direvent.html"
  url "https://ftpmirror.gnu.org/gnu/direvent/direvent-5.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/direvent/direvent-5.5.tar.gz"
  sha256 "0e16c0b4b3e6f7673e9b4f31d81ab01236ad22f83538512f3b2f58f9f96fdcb7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e8fb05e4952c404bca7747763e5b89306e2d5798c34ebc0d529839b8d8c84f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bd9c561ab944e4e65c9038a8633e10fb565c7142a4eda3b2ffbf80f2e428ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cbf030c671bac1317b108fd1f1f2c129f2d4f14e45a1617f863c1961ff40d8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e852aae83bb1ea9c260a98780c04e5b3374b953de7a3ac43c397f8b34458b1d"
    sha256                               arm64_linux:   "f655eb398b490fe9a373fecbbebec19b828093af0436b4d815ec820ce4e6d15c"
    sha256                               x86_64_linux:  "8a840cfc3743fa20d287a10da4b552b5c445f5d52152972c3a32a600dbc53378"
  end

  # Fix macOS build: clock_nanosleep/TIMER_ABSTIME are unavailable.
  # Issue ref: https://puszcza.gnu.org.ua/bugs/index.php?678
  patch :DATA

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direvent --version")
  end
end

__END__
--- a/src/progman.c
+++ b/src/progman.c
@@ -244,6 +244,32 @@
 	}
 }

+/*
+ * Sleep until the absolute DEADLINE (CLOCK_MONOTONIC).  Returns non-zero if
+ * interrupted by a signal (so the caller loops again), zero once the deadline
+ * is reached.  clock_nanosleep with TIMER_ABSTIME is not available everywhere
+ * (e.g. macOS), so fall back to a relative nanosleep there.
+ */
+static int
+drain_wait(struct timespec *deadline)
+{
+#ifdef TIMER_ABSTIME
+	return clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, deadline, NULL);
+#else
+	struct timespec now, rel;
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	rel.tv_sec = deadline->tv_sec - now.tv_sec;
+	rel.tv_nsec = deadline->tv_nsec - now.tv_nsec;
+	if (rel.tv_nsec < 0) {
+		rel.tv_nsec += NANOSEC;
+		--rel.tv_sec;
+	}
+	if (rel.tv_sec < 0)
+		return 0;
+	return nanosleep(&rel, NULL);
+#endif
+}
+
 void
 process_drain(void)
 {
@@ -263,8 +289,7 @@

 	do {
 		process_cleanup(1);
-	} while (proc_list &&
-		 clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL));
+	} while (proc_list && drain_wait(&ts));


 	if (proc_list) {
