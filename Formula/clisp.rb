class Clisp < Formula
  desc "GNU CLISP, a Common Lisp implementation"
  homepage "https://clisp.sourceforge.io/"
  license "GPL-2.0-or-later"

  stable do
    url "https://alpha.gnu.org/gnu/clisp/clisp-2.49.92.tar.bz2"
    sha256 "bd443a94aa9b02da4c4abbcecfc04ffff1919c0a8b0e7e35649b86198cd6bb89"

    # Fix build on ARM.
    # Remove once https://gitlab.com/gnu-clisp/clisp/-/commit/39b68a14d9a1fcde8a357c088c7317b19ff598ad is released.
    patch :DATA
  end

  livecheck do
    url "https://ftp.gnu.org/gnu/clisp/release/?C=M&O=D"
    strategy :page_match
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur:  "05bfe89f749c669150e3c9d4589a18ac0e5ffe9d3c27cc3da67fa41ad20a9258"
    sha256 cellar: :any, catalina: "b6a273e26d27a1bd3c8654631f2cd6fe964f0b9fc83d11ddb74513243378217e"
    sha256 cellar: :any, mojave:   "ee265923cfb2f5943d513a98b4205b57df9317ebf36a0faa4f29f3ee0c3734c2"
  end

  head do
    url "https://gitlab.com/gnu-clisp/clisp.git"
  end

  depends_on "libsigsegv"
  depends_on "readline"

  def install
    ENV.deparallelize # This build isn't parallel safe.
    ENV.O0 # Any optimization breaks the build

    # Clisp requires to select word size explicitly this way,
    # set it in CFLAGS won't work.
    ENV["CC"] = "#{ENV.cc} -m64"

    # Work around "configure: error: unrecognized option: `--elispdir"
    # Upstream issue 16 Aug 2016 https://sourceforge.net/p/clisp/bugs/680/
    inreplace "src/makemake.in", "${datarootdir}/emacs/site-lisp", elisp

    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=yes"

    cd "src" do
      # Multiple -O options will be in the generated Makefile,
      # make Homebrew's the last such option so it's effective.
      inreplace "Makefile" do |s|
        s.change_make_var! "CFLAGS", "#{s.get_make_var("CFLAGS")} #{ENV["CFLAGS"]}"
      end

      # The ulimit must be set, otherwise `make` will fail and tell you to do so
      system "ulimit -s 16384 && make"

      system "make", "install"
    end
  end

  test do
    system "#{bin}/clisp", "--version"
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
