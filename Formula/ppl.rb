class Ppl < Formula
  desc "Parma Polyhedra Library: numerical abstractions for analysis, verification"
  homepage "https://www.bugseng.com/ppl"
  url "https://www.bugseng.com/products/ppl/download/ftp/releases/1.2/ppl-1.2.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/p/ppl/ppl_1.2.orig.tar.xz"
  sha256 "691f0d5a4fb0e206f4e132fc9132c71d6e33cdda168470d40ac3cf62340e9a60"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.bugseng.com/ppl-download"
    regex(/href=.*?ppl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3b7d7b75d9c40347d165192e5189725d94129dc5f95d848cc86251f493ccef91"
    sha256 arm64_big_sur:  "f607e5d5ebefa0cb480bc84b1ba6e4eb1f2f07e7d7a00ae1f4c71958b5c82323"
    sha256 monterey:       "f75956df3abc16149ff87a0df7347973863331d8cadad40fef8dc3b760bfd6cf"
    sha256 big_sur:        "ceae5dd7024558587efdf935a870154a38e0cbf7e4882ba507cb3cebf574bed3"
    sha256 catalina:       "65aa31c0201a860d32e874ab34cbdea7132101fc6461510e06641a11ca762e82"
    sha256 mojave:         "253714635b8718e7822853e1385c546b665450b7059e8067e4008ed865eae261"
    sha256 high_sierra:    "7a9b9ceabcf71bf31ed8185caaa6e78c065511ba3e6cf805be13402983c2a7e1"
    sha256 x86_64_linux:   "09999d2760a2d719f28918c3040eadeceffd32112eee8e5f28f5b93db80d4d9d"
  end

  depends_on "gmp"

  on_linux do
    depends_on "m4" => :build
  end

  # Fix build failure with clang 5+.
  # https://www.cs.unipr.it/mantis/view.php?id=2128
  # http://www.cs.unipr.it/git/gitweb.cgi?p=ppl/ppl.git;a=commit;h=c39f6a07b51f89e365b05ba4147aa2aa448febd7
  # since 401 error on the `www.cs.unipr.it` links adopt the patch from macports
  # patch reference, https://github.com/macports/macports-ports/commit/e5de9cc65a8e91fcbb9a3d90911569169f0ccf88
  patch :DATA

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ppl_c.h>
      #ifndef PPL_VERSION_MAJOR
      #error "No PPL header"
      #endif
      int main() {
        ppl_initialize();
        return ppl_finalize();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lppl_c", "-lppl", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/src/Determinate_inlines.hh b/src/Determinate_inlines.hh
index c918b23..de672a0 100644
--- a/src/Determinate_inlines.hh
+++ b/src/Determinate_inlines.hh
@@ -289,8 +289,8 @@ operator()(Determinate& x, const Determinate& y) const {

 template <typename PSET>
 template <typename Binary_Operator_Assign>
-inline
-Determinate<PSET>::Binary_Operator_Assign_Lifter<Binary_Operator_Assign>
+inline typename
+Determinate<PSET>::template Binary_Operator_Assign_Lifter<Binary_Operator_Assign>
 Determinate<PSET>::lift_op_assign(Binary_Operator_Assign op_assign) {
   return Binary_Operator_Assign_Lifter<Binary_Operator_Assign>(op_assign);
 }
diff --git a/src/OR_Matrix_inlines.hh b/src/OR_Matrix_inlines.hh
index a5f2856..560f8d6 100644
--- a/src/OR_Matrix_inlines.hh
+++ b/src/OR_Matrix_inlines.hh
@@ -97,7 +97,7 @@ OR_Matrix<T>::Pseudo_Row<U>::Pseudo_Row(const Pseudo_Row<V>& y)

 template <typename T>
 template <typename U>
-inline OR_Matrix<T>::Pseudo_Row<U>&
+inline typename OR_Matrix<T>::template Pseudo_Row<U>&
 OR_Matrix<T>::Pseudo_Row<U>::operator=(const Pseudo_Row& y) {
   first = y.first;
 #if PPL_OR_MATRIX_EXTRA_DEBUG
