class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "https://ftpmirror.gnu.org/gnu/lightning/lightning-2.2.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/lightning/lightning-2.2.3.tar.gz"
  sha256 "c045c7a33a00affbfeb11066fa502c03992e474a62ba95977aad06dbc14c6829"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e7c4c0c882b4401d5ec4866e90d7f67b719af0b8bfcf62a527e4441b7c18399d"
    sha256 cellar: :any,                 arm64_sequoia:  "d1d35078fe7268b6f043717f1e8e855ac36bc227f78bae0ee3db7dac45cfbfb0"
    sha256 cellar: :any,                 arm64_sonoma:   "c473bf328b70cd3d6e61088ced3ecd303dbd240e86e01e3bdfa84d9f41180022"
    sha256 cellar: :any,                 arm64_ventura:  "e9068aa64aad7d959c4b20534a8b0e2cab3bc5187b5ccf66e0f800ac0fb65cad"
    sha256 cellar: :any,                 arm64_monterey: "315b27475a274908edb9c5a9f391efacf0888d8ddea0f5b2374a07c11d888978"
    sha256 cellar: :any,                 sonoma:         "6bbab88edb452016502a26349f899eb4c4a5547b698c6496d78df6ed7c012fb8"
    sha256 cellar: :any,                 ventura:        "4b560322ed7277918cc27b34064730088f37560d0aec5f8b6e7389db5c5813c2"
    sha256 cellar: :any,                 monterey:       "149a92d3f323b5f4b52481c3eeba41aad3ba6fede45859159ac3a4de041e0a17"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5af0fa5ffd268c4d721624a01ee21826d6a5bbcccd277be7f12a6ce1df7f32ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8a31092e058742cf79549bb7d50979296326151bec52214ea580dc823748a20"
  end

  depends_on "binutils" => :build

  # upstream patch for fixing `Correct wrong ifdef causing missing mprotect call if NDEBUG is not defined`
  patch do
    url "https://cgit.git.savannah.gnu.org/cgit/lightning.git/patch/?id=bfd695a94668861a9447b29d2666f8b9c5dcd5bf"
    sha256 "9264f463ce98e090e1386dd328cf02d542609c6375a6968d4024fbe8a6cabf8b"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    # from https://www.gnu.org/software/lightning/manual/lightning.html#incr
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <lightning.h>
      static jit_state_t *_jit;
      typedef int (*pifi)(int);
      int main(int argc, char *argv[]) {
        jit_node_t  *in;
        pifi incr;
        init_jit(argv[0]);
        _jit = jit_new_state();
        jit_prolog();
        in = jit_arg();
        jit_getarg(JIT_R0, in);
        jit_addi(JIT_R0, JIT_R0, 1);
        jit_retr(JIT_R0);
        incr = jit_emit();
        jit_clear_state();
        printf("%d + 1 = %d\\n", 5, incr(5));
        jit_destroy_state();
        finish_jit();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-llightning", "-o", "test"
    system "./test"
  end
end
