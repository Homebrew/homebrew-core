class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"
  revision 6

  bottle do
    sha256 cellar: :any, arm64_monterey: "b1b79b163aa6caf6bda95defe34d5ea891c5cec0e134d02aea71c9d9939d3af8"
    sha256 cellar: :any, arm64_big_sur:  "06cc3ac71a633a0588edcc8a61872660ef33f5301949eb73c2796feeb7994d9f"
    sha256 cellar: :any, monterey:       "da984e6f108145570e8acf10797c2cf779d2d99368f8863c4deb53048c24cf1c"
    sha256 cellar: :any, big_sur:        "8e8832be92d504b671f833b993ffa5f00b40cea7af1c41fea910d54f5fb4ed7b"
    sha256 cellar: :any, catalina:       "cb2266d78836d4aa751eca4eeaed96e6df7fbe160fb9a0a996f4eb9dfa3eacc1"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "gsl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  # Fix issue with conflicting definitions of select on Linux.
  # Patch submitted to discussion group:
  # https://groups.google.com/g/oscats/c/WZ7gRjkxmIk.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples"
    # Fix shim references in examples Makefile.
    if OS.mac?
      inreplace pkgshare/"examples/Makefile",
        Superenv.shims_path/"pkg-config",
        Formula["pkg-config"].opt_bin/"pkg-config"
    else
      inreplace pkgshare/"examples/Makefile", Superenv.shims_path/"ld", "ld"
    end
  end

  test do
    pkg_config_flags = shell_output("pkg-config --cflags --libs oscats glib-2.0").chomp.split
    system ENV.cc, pkgshare/"examples/ex01.c", *pkg_config_flags, "-o", "ex01"
    assert_match "Done", shell_output("#{testpath}/ex01")
  end
end

__END__
diff --git a/src/liboscats/algorithms/closest_diff.c b/src/liboscats/algorithms/closest_diff.c
index 86f7f2f..97de5d9 100644
--- a/src/liboscats/algorithms/closest_diff.c
+++ b/src/liboscats/algorithms/closest_diff.c
@@ -175,7 +175,7 @@ static gdouble criterion(const OscatsItem *item, OscatsExaminee *e,
   return oscats_model_distance(model, theta, e->covariates);
 }
 
-static gint select (OscatsTest *test, OscatsExaminee *e,
+static gint select_algorithm (OscatsTest *test, OscatsExaminee *e,
                     GBitArray *eligible, gpointer alg_data)
 {
   return oscats_alg_chooser_choose(OSCATS_ALG_CLOSEST_DIFF(alg_data)->chooser,
@@ -194,7 +194,7 @@ static void alg_register (OscatsAlgorithm *alg_data, OscatsTest *test)
   OscatsAlgClosestDiff *self = OSCATS_ALG_CLOSEST_DIFF(alg_data);
   self->chooser->bank = g_object_ref(test->itembank);
   self->chooser->criterion = (OscatsAlgChooserCriterion)criterion;
-  g_signal_connect_data(test, "select", G_CALLBACK(select),
+  g_signal_connect_data(test, "select", G_CALLBACK(select_algorithm),
                         alg_data, oscats_algorithm_closure_finalize, 0);
 }
                    
diff --git a/src/liboscats/algorithms/max_fisher.c b/src/liboscats/algorithms/max_fisher.c
index 16c8b39..0835bf6 100644
--- a/src/liboscats/algorithms/max_fisher.c
+++ b/src/liboscats/algorithms/max_fisher.c
@@ -265,7 +265,7 @@ static gdouble criterion(const OscatsItem *item,
     // max det[sum I_j(theta)] <==> min -det[sum I_j(theta)]
 }
 
-static gint select (OscatsTest *test, OscatsExaminee *e,
+static gint select_algorithm (OscatsTest *test, OscatsExaminee *e,
                     GBitArray *eligible, gpointer alg_data)
 {
   OscatsAlgMaxFisher *self = OSCATS_ALG_MAX_FISHER(alg_data);
@@ -298,7 +298,7 @@ static void alg_register (OscatsAlgorithm *alg_data, OscatsTest *test)
 
   g_signal_connect_data(test, "initialize", G_CALLBACK(initialize),
                         alg_data, oscats_algorithm_closure_finalize, 0);
-  g_signal_connect_data(test, "select", G_CALLBACK(select),
+  g_signal_connect_data(test, "select", G_CALLBACK(select_algorithm),
                         alg_data, oscats_algorithm_closure_finalize, 0);
   g_object_ref(alg_data);
 }
diff --git a/src/liboscats/algorithms/max_kl.c b/src/liboscats/algorithms/max_kl.c
index ac9a53e..95c74a3 100644
--- a/src/liboscats/algorithms/max_kl.c
+++ b/src/liboscats/algorithms/max_kl.c
@@ -623,7 +623,7 @@ static gdouble criterion(const OscatsItem *item,
                                  alg_data);
 }
 
-static gint select (OscatsTest *test, OscatsExaminee *e,
+static gint select_algorithm (OscatsTest *test, OscatsExaminee *e,
                     GBitArray *eligible, gpointer alg_data)
 {
   OscatsAlgMaxKl *self = OSCATS_ALG_MAX_KL(alg_data);
@@ -661,7 +661,7 @@ static void alg_register (OscatsAlgorithm *alg_data, OscatsTest *test)
 
   g_signal_connect_data(test, "initialize", G_CALLBACK(initialize),
                         alg_data, oscats_algorithm_closure_finalize, 0);
-  g_signal_connect_data(test, "select", G_CALLBACK(select),
+  g_signal_connect_data(test, "select", G_CALLBACK(select_algorithm),
                         alg_data, oscats_algorithm_closure_finalize, 0);
   g_object_ref(alg_data);
 }
diff --git a/src/liboscats/algorithms/pick_rand.c b/src/liboscats/algorithms/pick_rand.c
index 1e66758..ef6234c 100644
--- a/src/liboscats/algorithms/pick_rand.c
+++ b/src/liboscats/algorithms/pick_rand.c
@@ -35,7 +35,7 @@ static void oscats_alg_pick_rand_init (OscatsAlgPickRand *self)
 {
 }
 
-static gint select (OscatsTest *test, OscatsExaminee *e,
+static gint select_algorithm (OscatsTest *test, OscatsExaminee *e,
                     GBitArray *eligible, gpointer alg_data)
 {
   guint i, item = 0;
@@ -55,7 +55,7 @@ static gint select (OscatsTest *test, OscatsExaminee *e,
  */
 static void alg_register (OscatsAlgorithm *alg_data, OscatsTest *test)
 {
-  g_signal_connect_data(test, "select", G_CALLBACK(select),
+  g_signal_connect_data(test, "select", G_CALLBACK(select_algorithm),
                         alg_data, oscats_algorithm_closure_finalize, 0);
 }
                    
