class Ministat < Formula
  desc "Small tool to do the statistics legwork on benchmarks etc."
  homepage "https://github.com/freebsd/freebsd-src/tree/main/usr.bin/ministat"
  url "http://deb.debian.org/debian/pool/main/m/ministat/ministat_20150715.orig.tar.gz"
  sha256 "847fd40547e15d93b304660e7c834667c6b79f6f7d80405f72695a6a25b288b4"
  license all_of: ["Beerware", "BSD-2-Clause"]

  patch :DATA

  def install
    system ENV.cc, "-lm", "-o", "ministat", "ministat.c"
    bin.install "ministat"
    (pkgshare/"examples").install "iguana"
    man1.install "ministat.1"
  end

  test do
    assert_match(/ 238\.04761$/, shell_output("#{bin}/ministat -A #{pkgshare}/examples/iguana"))
  end
end

__END__
diff --git a/ministat.c b/ministat.c
index 30b9379..1e16a4f 100644
--- a/ministat.c
+++ b/ministat.c
@@ -250,7 +250,7 @@ Relative(struct dataset *ds, struct dataset *rs, int confidx)
 	e = t * s;
 
 	if (fabs(d) > e) {
-	
+
 		printf("Difference at %.1f%% confidence\n", studentpct[confidx]);
 		printf("	%g +/- %g\n", d, e);
 		printf("	%g%% +/- %g%%\n", d * 100 / Avg(rs), e * 100 / Avg(rs));
@@ -340,7 +340,7 @@ PlotSet(struct dataset *ds, int val)
 		pl->bar[bar] = malloc(pl->width);
 		memset(pl->bar[bar], 0, pl->width);
 	}
-	
+
 	m = 1;
 	i = -1;
 	j = 0;
@@ -616,7 +616,7 @@ main(int argc, char **argv)
 			ds[i] = ReadSet(argv[i], column, delim);
 	}
 
-	for (i = 0; i < nds; i++) 
+	for (i = 0; i < nds; i++)
 		printf("%c %s\n", symbol[i+1], ds[i]->name);
 
 	if (!flag_n && !suppress_plot) {
