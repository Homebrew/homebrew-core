class Gcl < Formula
  desc "GNU Common Lisp"
  homepage "https://www.gnu.org/software/gcl/"
  url "https://ftpmirror.gnu.org/gcl/gcl-2.7.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gcl/gcl-2.7.1.tar.gz"
  sha256 "79d0bb65b82df81c078bc55c4cda3fe4d766d87e3bfe10fde0b2f728204e1015"
  license all_of: [
    "LGPL-2.0-or-later",
    "GPL-1.0-or-later", # elisp/sshell.el
    "LOOP", # mod/gcl_loop.lsp
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "dfa35d12b4ccf9fb802cbfef7fdc2e8300734a3d6eb375520db4070ef8b5428d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "28c991bd2a4fcde47e5ed5199c69d521406cfe75a1e84b9b9ac282b6c3bbe384"
  end

  depends_on "gmp"
  depends_on "libtirpc"
  depends_on :linux

  # Apply official errata for 2.7.1 release which include following commits
  # https://cgit.git.savannah.gnu.org/cgit/gcl.git/commit/gcl?id=7356875684eaf4fbedb5a660abefeb2b633105a0
  # https://cgit.git.savannah.gnu.org/cgit/gcl.git/commit/gcl?id=3f9d2eeda182741a0e6ddf05cad9aff0fcb84ca5
  # And backport fix needed for Homebrew's non-lowercase CC path
  # https://cgit.git.savannah.gnu.org/cgit/gcl.git/commit/gcl?id=fd8984c0fcdaa45ff4296ebfdf13eddd12c2362b
  patch :DATA

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["libtirpc"].opt_include}/tirpc"
    ENV["GCL_MULTIPROCESS_MEMORY_POOL"] = buildpath

    system "./configure", "--disable-silent-rules", "--with-lispdir=#{elisp}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"main.lisp").write <<~LISP
      #!#{bin}/gcl -f
      (format t "Hello, World!")
    LISP
    assert_equal "Hello, World!", shell_output("#{bin}/gcl -f main.lisp").chomp
  end
end

__END__
--- a/git.tag
+++ b/git.tag
@@ -1,2 +1,2 @@
-"Version_2_7_0"
+"Version_2_7_1"
 
--- a/o/alloc.c
+++ b/o/alloc.c
@@ -707,6 +707,7 @@ empty_relblock(void) {
   for (;!rb_emptyp();) {
     tm_table[t_relocatable].tm_adjgbccnt--;
     expand_contblock_index_space();
+    expand_contblock_array();
     GBC(t_relocatable);
   }
   sSAleaf_collection_thresholdA->s.s_dbind=o;
--- a/lsp/gcl_directory.lsp
+++ b/lsp/gcl_directory.lsp
@@ -75,8 +75,7 @@
   (let ((r (with-open-file (s (apply 'string-concatenate "|" #-winnt "command -v "
 				     #+winnt "for %i in (" s #+winnt ".exe) do @echo.%~$PATH:i" nil))
 			   (read-line s nil 'eof))))
-    (unless (eq r 'eof)
-      (string-downcase r))))
+    (unless (eq r 'eof) r)))
 
 (defun get-path (s &aux
 		   (e (unless (minusp (string-match #v"([^\n\t\r ]+)([\n\t\r ]|$)" s))(match-end 1)))
