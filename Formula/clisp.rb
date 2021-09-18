class Clisp < Formula
  desc "GNU CLISP, a Common Lisp implementation"
  homepage "https://clisp.sourceforge.io/"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/gnu-clisp/clisp.git", branch: "master"

  stable do
    url "https://alpha.gnu.org/gnu/clisp/clisp-2.49.92.tar.bz2"
    sha256 "bd443a94aa9b02da4c4abbcecfc04ffff1919c0a8b0e7e35649b86198cd6bb89"

    # Fix build on ARM
    # Remove once https://gitlab.com/gnu-clisp/clisp/-/commit/39b68a14d9a1fcde8a357c088c7317b19ff598ad is released,
    # which contains the necessary patch to the bundled gnulib
    # https://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=commit;h=00e688fc22c7bfb0bba2bd8a7b2a7d22d21d31ef
    patch :DATA
  end

  livecheck do
    url "https://ftp.gnu.org/gnu/clisp/release/?C=M&O=D"
    strategy :page_match
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur:      "05bfe89f749c669150e3c9d4589a18ac0e5ffe9d3c27cc3da67fa41ad20a9258"
    sha256 cellar: :any, catalina:     "b6a273e26d27a1bd3c8654631f2cd6fe964f0b9fc83d11ddb74513243378217e"
    sha256 cellar: :any, mojave:       "ee265923cfb2f5943d513a98b4205b57df9317ebf36a0faa4f29f3ee0c3734c2"
    sha256               x86_64_linux: "46135189dd1acbfdcae88e81b78d90be6fce1d9b19e853d1c610cc9e146c8597"
  end

  depends_on "libsigsegv"
  depends_on "readline"

  def install
    system "./configure", *std_configure_args,
                          "--with-readline=yes",
                          "--elispdir=#{elisp}"

    cd "src" do
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"main.lisp").write <<~EOS
      (format t "Hello, World!")
    EOS
    assert_equal "Hello, World!", shell_output(bin/"clisp main.lisp").chomp
  end
end

__END__
--- a/src/gllib/vma-iter.c
+++ b/src/gllib/vma-iter.c
@@ -1327,7 +1327,7 @@
          In 64-bit processes, we could use vm_region_64 or mach_vm_region.
          I choose vm_region_64 because it uses the same types as vm_region,
          resulting in less conditional code.  */
-# if defined __ppc64__ || defined __x86_64__
+# if defined __aarch64__ || defined __ppc64__ || defined __x86_64__
       struct vm_region_basic_info_64 info;
       mach_msg_type_number_t info_count = VM_REGION_BASIC_INFO_COUNT_64;
