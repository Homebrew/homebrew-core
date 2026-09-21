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
    url "https://alpha.gnu.org/gnu/clisp/?C=M&O=D"
    regex(/href=.*?clisp[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "3d72c06219102d616fe394651760e449ea6d03341c1e936721d0a746e48175c2"
    sha256 cellar: :any, arm64_tahoe:       "3af53aa873a0ed7d2e43fac7c09fd80c127e2069d69a814422362dc2e66fc264"
    sha256 cellar: :any, arm64_sequoia:     "6333c511593cd930393b6b446ec2e60ab6a5acb75ebad2f6a383b0b8f6b6be1a"
    sha256               arm64_linux:       "5814eb822b3860e8e627393f15784d47fd2ee41ffdd6d87c74455275cd8c504c"
    sha256               x86_64_linux:      "7360777f3cbc613fd1d35b0947cafda3f0e1b9fd2fccab604207b53447ab91a5"
  end

  depends_on "libffcall"
  depends_on "libsigsegv"
  depends_on "readline"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1700
  end

  fails_with :clang do
    build 1700
  end

  def install
    # FIXME: Apple clang 21 miscompiles clisp, making `compile-file` trip an
    # assertion in `c-TEST/TEST-NOT`. Upstream's unreleased "fix" uses `-O0`
    # on certain files but this won't work within the superenv
    if DevelopmentTools.clang_build_version >= 2100 || ENV.compiler == :llvm_clang
      ENV.append_to_cflags "-fwrapv-pointer"
    end

    # FIXME: the Linux sandbox denies ioctl which causes clisp to use the same
    # fd for stdout and stderr so `2>/dev/null` discards all output.
    if OS.linux?
      inreplace Dir["modules/*/configure"], %r{(\$cl_cv_clisp -q -norc -x '[^']*') 2>/dev/null}, "\\1"
      inreplace "src/clisp-link.in", '${CLISP} -q -x "$*" 2>/dev/null', '${CLISP} -q -x "$*"'
    end

    system "./configure", "--with-readline=yes",
                          "--elispdir=#{elisp}",
                          *std_configure_args

    # Module configures share `config.cache` and race under parallel make
    ENV.deparallelize

    cd "src" do
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"main.lisp").write <<~LISP
      (format t "Hello, World!")
    LISP
    assert_equal "Hello, World!", shell_output("#{bin}/clisp main.lisp").chomp
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
