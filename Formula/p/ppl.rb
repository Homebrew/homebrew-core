class Ppl < Formula
  desc "Parma Polyhedra Library: numerical abstractions for analysis, verification"
  homepage "https://www.bugseng.com/ppl"
  url "https://deb.debian.org/debian/pool/main/p/ppl/ppl_1.2.orig.tar.xz"
  sha256 "691f0d5a4fb0e206f4e132fc9132c71d6e33cdda168470d40ac3cf62340e9a60"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://deb.debian.org/debian/pool/main/p/ppl/"
    regex(/href=.*?ppl[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "aea93f11cba2f9c6d6d64225405165be26d8ae84d9f668cdfd5f479a5a53e169"
    sha256 arm64_sequoia:  "527d1a14323856ce82d73c94a18da7b53363c5f9064de4f70dda5a5aa1c84ee6"
    sha256 arm64_sonoma:   "72645288d73cc251a6310649cbd8782c07438ce56d1a66fe190ceea5e7a10782"
    sha256 arm64_ventura:  "7b34ee3fa741ad47e0ec32a5fac0dffddea220097ea7938618586d1b1016f9ba"
    sha256 arm64_monterey: "3b7d7b75d9c40347d165192e5189725d94129dc5f95d848cc86251f493ccef91"
    sha256 arm64_big_sur:  "f607e5d5ebefa0cb480bc84b1ba6e4eb1f2f07e7d7a00ae1f4c71958b5c82323"
    sha256 sonoma:         "a67e256076ad9de40aa134fe1ea3ae194fc1ef12454f0e637d74c4a037037722"
    sha256 ventura:        "c37e9a48bbaa4eee1c8c25b3e04cb6886da8bc19f684316dd93c7c121ba262c1"
    sha256 monterey:       "f75956df3abc16149ff87a0df7347973863331d8cadad40fef8dc3b760bfd6cf"
    sha256 big_sur:        "ceae5dd7024558587efdf935a870154a38e0cbf7e4882ba507cb3cebf574bed3"
    sha256 catalina:       "65aa31c0201a860d32e874ab34cbdea7132101fc6461510e06641a11ca762e82"
    sha256 arm64_linux:    "cae59d336bc919b7924cf6507ed0fef355e1a9ecc9770f06cc34cd05741d96df"
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
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
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
    (testpath/"test.c").write <<~C
      #include <ppl_c.h>
      #ifndef PPL_VERSION_MAJOR
      #error "No PPL header"
      #endif
      int main() {
        ppl_initialize();
        return ppl_finalize();
      }
    C
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
