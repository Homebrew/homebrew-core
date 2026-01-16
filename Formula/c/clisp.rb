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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7c6012970cf0b4c270ea9144deb1aa018a820f333dd0a23c98116a6da81cdccd"
    sha256 cellar: :any, arm64_sequoia: "ddfc9a191f0afb4b3763164759e47df9e6eabec853dd60a1575a83d040309003"
    sha256 cellar: :any, arm64_sonoma:  "82b6891a410f0c7c212fed6e18527102ad9180d0003ccf3e24bb8d8071d37353"
    sha256 cellar: :any, sonoma:        "a4225bd790a152ba74e307d69ff945b69aa0c04fc43b1c98b67298085300c129"
    sha256               arm64_linux:   "21dbffbe262f2cd831a5b80be895bb1747d5e58091f28d5067be710cab22d832"
    sha256               x86_64_linux:  "ac69bd943aac71e7e7d782747b3e3369923e13cb8de3990c3afe6adf90e42ba2"
  end

  depends_on "libffcall"
  depends_on "libsigsegv"
  depends_on "readline"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    system "./configure", "--with-readline=yes",
                          "--elispdir=#{elisp}",
                          *std_configure_args

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
