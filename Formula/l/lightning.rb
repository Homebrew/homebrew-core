class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "https://ftp.gnu.org/gnu/lightning/lightning-2.2.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/lightning/lightning-2.2.2.tar.gz"
  sha256 "0aca8242dead17d62117bcfcb078e6a9ea856cc81742813c9e8394bcce73b3e2"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "6ca49f5cfa9fee14775858599b92931e40247ec418ab2a905e70081d283a0193"
    sha256 cellar: :any,                 arm64_ventura:  "b4871a4e6037699bc9b26f377453818a78f1d5a1167d4bc1451ec855fd6e70d2"
    sha256 cellar: :any,                 arm64_monterey: "b88f2e86b5a1658f6055b88038d20dee12312075a8c5e564110c257cabcc8496"
    sha256 cellar: :any,                 sonoma:         "0fb798ce3c9f7fd27c6f085d8d7780b7c66860685bae784443589eb5524ce52a"
    sha256 cellar: :any,                 ventura:        "e856a9e8628e8ac35417af45ccbfd948f9fd7e0cac62c3bb3c615de5f70bb4b5"
    sha256 cellar: :any,                 monterey:       "6aa258f975222cd835c88a934fc1c7dca3f67343d65a36443b128559524a1149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55ccd9e5c6224b62caf0678331de3ecf28bcf327014f4d0aed43ee05cd88264f"
  end

  depends_on "binutils" => :build

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    # from https://www.gnu.org/software/lightning/manual/lightning.html#incr
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-llightning", "-o", "test"
    system "./test"
  end
end
