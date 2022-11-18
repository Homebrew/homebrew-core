class Clisp < Formula
  desc "GNU CLISP, a Common Lisp implementation"
  homepage "https://clisp.sourceforge.io/"
  license "GPL-2.0-or-later"
  revision 1
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
    sha256 cellar: :any, arm64_ventura:  "2be9e60ec5595599b60733d43ade1ea29007214d3c05837d58cffc43bfb6e412"
    sha256 cellar: :any, arm64_monterey: "bfad1c6c3b4787711bc126ed360647a6ad6458dd24ff4cd9e3be5252b897ed82"
    sha256 cellar: :any, arm64_big_sur:  "8108810c5af0ce990d9052ca96f6aa75af1f59589a103e21a86f8b1f2e801956"
    sha256 cellar: :any, ventura:        "16c062ce5c0d6ff467fe082d36bc22a0455972c19a34e37520eb0134f77b24ec"
    sha256 cellar: :any, monterey:       "b2fc7c67341df7f9766f66054445e342bd61acc22c7260bac3589266ba78f8a3"
    sha256 cellar: :any, big_sur:        "4b81399840c98918cda6447d86852ffcb96294f228cb26f6c289f22d90df5a7a"
    sha256 cellar: :any, catalina:       "de714225b132ed2cdf971fd31befd890f336a3a917a5fd56832d6989b6c28a58"
    sha256               x86_64_linux:   "c62c710ca923611df8d28202e49b0ca27eba36a4d0736a01e482b453d53769e1"
  end

  depends_on "libsigsegv"
  depends_on "readline"
  uses_from_macos "libxcrypt"

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
