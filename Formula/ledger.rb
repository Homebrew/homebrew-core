class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.2.1.tar.gz"
  sha256 "92bf09bc385b171987f456fe3ee9fa998ed5e40b97b3acdd562b663aa364384a"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/ledger/ledger.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "2606457bb4b8596b5502ce4a4f1e61d62e71fa29118987ff14eb6b7d26d81368"
    sha256 big_sur:       "b65a9b4ec2be3cc44503122ec6dcb41d1101fa3425a64b197b08743fe3aaad84"
    sha256 catalina:      "be65eaa4610eb98628f7c3abaf5582dd0ab145a991275e2550e48cebc313a012"
    sha256 mojave:        "47990a19ee10042ffb198cb105cb9c56a11a3d8db606166f57a57c9a9c89620a"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.9"

  uses_from_macos "groff"

  # Compatibility with Boost 1.76
  # https://github.com/ledger/ledger/issues/2030
  patch :DATA

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
      -DBoost_NO_BOOST_CMAKE=ON
      -DPython_FIND_VERSION_MAJOR=3
    ] + std_cmake_args
    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
    bash_completion.install pkgshare/"contrib/ledger-completion.bash"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", "#{pkgshare}/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end

__END__
diff --git a/src/expr.cc b/src/expr.cc
index c8945d3..136fc97 100644
--- a/src/expr.cc
+++ b/src/expr.cc
@@ -34,6 +34,7 @@
 #include "expr.h"
 #include "parser.h"
 #include "scope.h"
+#include <memory>

 namespace ledger {

@@ -278,7 +279,7 @@ value_t expr_value(expr_t::ptr_op_t op)
 value_t source_command(call_scope_t& args)
 {
   std::istream * in = NULL;
-  scoped_ptr<ifstream> stream;
+  std::unique_ptr<ifstream> stream;
   string pathname;

   if (args.has(0)) {
diff --git a/src/format.h b/src/format.h
index 15431cf..c12f1c9 100644
--- a/src/format.h
+++ b/src/format.h
@@ -44,6 +44,7 @@

 #include "expr.h"
 #include "unistring.h"
+#include <memory>

 namespace ledger {

@@ -65,7 +66,7 @@ class format_t : public expr_base_t<string>, public noncopyable
     std::size_t                  min_width;
     std::size_t                  max_width;
     variant<string, expr_t>      data;
-    scoped_ptr<struct element_t> next;
+    std::unique_ptr<struct element_t> next;

     element_t() throw()
       : supports_flags<>(), type(STRING), min_width(0), max_width(0) {
@@ -103,7 +104,7 @@ class format_t : public expr_base_t<string>, public noncopyable
     void dump(std::ostream& out) const;
   };

-  scoped_ptr<element_t> elements;
+  std::unique_ptr<element_t> elements;

 public:
   static enum elision_style_t {
