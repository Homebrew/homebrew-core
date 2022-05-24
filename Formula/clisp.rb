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
    sha256 cellar: :any, arm64_monterey: "fd0612e62737575c94b319dfeaf34a7ef598422199313cc88bf980a3e9dca8c7"
    sha256 cellar: :any, arm64_big_sur:  "47b8617bc92bfcef6ce59ddb16ce923c49807d342c6086c41130def364f68bcd"
    sha256 cellar: :any, monterey:       "a681906d5fc0756209090b467e642c6d0ff899c333f9e5576e539a5347775a5e"
    sha256 cellar: :any, big_sur:        "ddb6cb44d70ff18bd12bd186679112e8f4fa1f33d4849697fa2564c51195b5fe"
    sha256 cellar: :any, catalina:       "2011ba42953cd6363aab0b23154947d364197fb28305efdb08ebe4640447d311"
    sha256 cellar: :any, mojave:         "2e74f9680f7b060a0d6a71b2fdae0d00fa6e6009af104f9fb7839368b109ae1f"
    sha256               x86_64_linux:   "80d7aa1e12fb3af6a08d6a5f53c5696cfdd0d277e54fdfb18108b13c4cee55f2"
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
